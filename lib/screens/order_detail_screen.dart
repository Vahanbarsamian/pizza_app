import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'add_review_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  final String status;

  const OrderDetailScreen({super.key, required this.order, required this.status});

  Future<void> _updateOrderStatus(BuildContext context, String newStatus) async {
    final adminService = context.read<AdminService>();
    final syncService = context.read<SyncService>();
    try {
      await adminService.updateOrderStatus(order.id, newStatus);
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

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final authService = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bon de Commande'),
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: db.getOrderItems(order.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun article trouvé pour cette commande.'));
          }

          final items = snapshot.data!;
          final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildOrderSummary(context, totalItems, authService.isAdmin),
              const Divider(height: 32),
              Text('Détails des articles', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...items.map((item) => OrderItemCard(item: item)),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(context, authService),
    );
  }

  Widget? _buildBottomBar(BuildContext context, AuthService authService) {
    if (authService.isAdmin) {
      if (status == 'À faire') {
        return _buildAdminButton(context, 'Marquer comme PRÊTE', 'Prête', Colors.green);
      }
      if (status == 'Prête') {
        return _buildAdminButton(context, 'Marquer comme TERMINÉE', 'Terminée', Colors.blue);
      }
      return null;
    }

    return StreamBuilder<Review?>(
      stream: context.read<AppDatabase>().watchReviewForOrder(order.id),
      builder: (context, snapshot) {
        final hasReview = snapshot.hasData && snapshot.data != null;
        if (hasReview || status != 'Terminée') {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('Laisser un avis'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AddReviewScreen(order: order),
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

  Widget _buildOrderSummary(BuildContext context, int totalItems, bool isAdmin) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ CORRIGÉ: Logique d'affichage du statut conditionnelle
            if (isAdmin)
              _buildSummaryRow('Statut:', status, isStatus: true)
            else
              _buildSummaryRow('Statut:', 'Payé le ${DateFormat('dd/MM/yyyy').format(order.createdAt)}', color: Colors.red),
            
            _buildSummaryRow('Référence:', order.referenceName ?? 'Non spécifié'),
            _buildSummaryRow('Heure de retrait:', order.pickupTime ?? 'Non spécifiée'),
            _buildSummaryRow('Date:', DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(order.createdAt)),
            _buildSummaryRow('Mode de paiement:', order.paymentMethod ?? 'Non spécifié'),
            _buildSummaryRow('Nombre d\'articles:', '$totalItems articles'),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(text: order.total.toStringAsFixed(2)),
                      const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ],
                  ),
                )
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
                Expanded(
                  child: Text(
                    '${item.quantity}x ${item.productName}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(text: (item.unitPrice * item.quantity).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            if (item.optionsDescription != null && item.optionsDescription!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('+ Suppléments: ${item.optionsDescription}', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
              ),
          ],
        ),
      ),
    );
  }
}
