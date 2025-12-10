import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'add_review_screen.dart';

String formatPrice(double price) {
  return '${price.toStringAsFixed(2)} € TTC';
}

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  final String status;

  const OrderDetailScreen({super.key, required this.order, required this.status});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {

  Future<void> _updateOrderStatus(BuildContext context, String newStatus) async {
    final adminService = context.read<AdminService>();
    final syncService = context.read<SyncService>();
    try {
      await adminService.updateOrderStatus(widget.order.id, newStatus);
      await syncService.syncAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Statut mis à jour: $newStatus'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _shareInvoice(CompanyInfoData? companyInfo, List<OrderItem> orderItems) async {
    if (companyInfo == null || orderItems.isEmpty) return;

    final companyName = companyInfo.name ?? 'Votre Pizzeria';
    final tvaRate = companyInfo.tvaRate ?? 0.0;

    final buffer = StringBuffer();
    buffer.writeln('--- FACTURE ---');
    buffer.writeln(companyName);
    if (companyInfo.address != null) buffer.writeln(companyInfo.address);
    buffer.writeln('--------------------');
    buffer.writeln('Commande pour: ${widget.order.referenceName}');
    buffer.writeln('Date: ${DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(widget.order.createdAt)}');
    buffer.writeln('--------------------');

    for (final item in orderItems) {
      buffer.writeln('${item.quantity}x ${item.productName} - ${formatPrice(item.unitPrice * item.quantity)}');
      if(item.optionsDescription != null && item.optionsDescription!.isNotEmpty) {
        final optionsText = item.optionsDescription!.replaceAll('(sans', '(SANS');
        buffer.writeln('  $optionsText');
      }
    }

    buffer.writeln('--------------------');
    double tvaAmount = 0;
    if (tvaRate > 0) {
        tvaAmount = widget.order.total / (1 + tvaRate) * tvaRate;
    }
    buffer.writeln('dont TVA (${(tvaRate * 100).toStringAsFixed(0)}%): ${tvaAmount.toStringAsFixed(2)} €');
    buffer.writeln('TOTAL: ${formatPrice(widget.order.total)}');
    buffer.writeln('--------------------');
    buffer.writeln('Merci de votre visite !');

    Share.share(buffer.toString(), subject: 'Facture de votre commande chez $companyName');
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final authService = context.watch<AuthService>();

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([db.getOrderItems(widget.order.id), db.getCompanyInfo()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(appBar: AppBar(title: const Text('Bon de Commande')), body: const Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData) {
           return Scaffold(appBar: AppBar(title: const Text('Erreur')), body: Center(child: Text('Erreur de chargement des données: ${snapshot.error}')));
        }

        final orderItems = snapshot.data![0] as List<OrderItem>;
        final companyInfo = snapshot.data![1] as CompanyInfoData?;
        final totalItems = orderItems.fold<int>(0, (sum, item) => sum + item.quantity);

        return Scaffold(
          appBar: AppBar(title: const Text('Bon de Commande')),
          body: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildOrderSummary(context, totalItems, authService.isAdmin, companyInfo),
                    const Divider(height: 32),
                    Text('Détails des articles', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    ...orderItems.map((item) => OrderItemCard(item: item)),
                  ],
                ),
          bottomNavigationBar: _buildBottomBar(context, authService),
          floatingActionButton: authService.isAdmin ? null : FloatingActionButton(
            onPressed: () => _shareInvoice(companyInfo, orderItems),
            tooltip: 'Partager la facture',
            child: const Icon(Icons.share),
          ),
        );
      },
    );
  }

  Widget? _buildBottomBar(BuildContext context, AuthService authService) {
    if (authService.isAdmin) {
      if (widget.status == 'À faire') {
        return _buildAdminButton(context, 'Marquer comme PRÊTE', 'Prête', Colors.green);
      }
      if (widget.status == 'Prête') {
        return _buildAdminButton(context, 'Marquer comme TERMINÉE', 'Terminée', Colors.blue);
      }
      return null;
    }

    return StreamBuilder<Review?>(
      stream: context.read<AppDatabase>().watchReviewForOrder(widget.order.id),
      builder: (context, snapshot) {
        final hasReview = snapshot.hasData && snapshot.data != null;
        if (hasReview || widget.status != 'Terminée') {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('Laisser un avis'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AddReviewScreen(order: widget.order),
              ));
            },
          ),
        );
      },
    );
  }

  Widget _buildAdminButton(BuildContext context, String label, String newStatus, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle_outline),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => _updateOrderStatus(context, newStatus),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, int totalItems, bool isAdmin, CompanyInfoData? companyInfo) {
    double tvaAmount = 0;
    double tvaRateForDisplay = 0;

    if (companyInfo?.tvaRate != null && companyInfo!.tvaRate! > 0) {
      final tvaRate = companyInfo.tvaRate!;
      tvaRateForDisplay = tvaRate * 100;
      tvaAmount = widget.order.total / (1 + tvaRate) * tvaRate;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAdmin) _buildSummaryRow('Statut:', widget.status, isStatus: true) else _buildSummaryRow('Statut:', 'Payé le ${DateFormat('dd/MM/yyyy').format(widget.order.createdAt)}', color: Colors.green),
            _buildSummaryRow('Référence:', widget.order.referenceName ?? 'Non spécifié'),
            _buildSummaryRow('Heure de retrait:', widget.order.pickupTime ?? 'Non spécifiée'),
            _buildSummaryRow('Date:', DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(widget.order.createdAt)),
            _buildSummaryRow('Mode de paiement:', widget.order.paymentMethod ?? 'Non spécifié'),
            _buildSummaryRow('Nombre d\'articles:', '$totalItems articles'),
            const Divider(height: 24, thickness: 1),
            if (tvaAmount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text('dont TVA (${tvaRateForDisplay.toStringAsFixed(0)}%): ${tvaAmount.toStringAsFixed(2)} €', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic))],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(formatPrice(widget.order.total), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isStatus = false, Color? color}) {
    Color getStatusColor() {
      switch (value) {
        case 'À faire': return Colors.red;
        case 'Prête': return Colors.green;
        case 'Terminée': return Colors.blueGrey;
        default: return Colors.black;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? (isStatus ? getStatusColor() : null), fontSize: isStatus ? 18 : null)),
        ],
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderItem item;

  const OrderItemCard({super.key, required this.item});

  // ✅ Logique de coloration améliorée
  Widget _buildOptionsText(BuildContext context) {
    final text = item.optionsDescription!;
    final defaultStyle = TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic);
    final redStyle = const TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);

    final spans = <TextSpan>[];
    final RegExp regExp = RegExp(r'\(sans.*?\)', caseSensitive: false);
    int currentPos = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > currentPos) {
        spans.add(TextSpan(text: text.substring(currentPos, match.start), style: defaultStyle));
      }
      spans.add(TextSpan(text: match.group(0), style: redStyle));
      currentPos = match.end;
    }

    if (currentPos < text.length) {
      spans.add(TextSpan(text: text.substring(currentPos), style: defaultStyle));
    }

    return Text.rich(TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('${item.quantity}x ${item.productName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Text(formatPrice(item.unitPrice * item.quantity), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            if (item.optionsDescription != null && item.optionsDescription!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildOptionsText(context),
              ),
          ],
        ),
      ),
    );
  }
}
