import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la commande'),
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
              // ✅ NOUVEAU: En-tête de résumé complet
              _buildOrderSummary(context, totalItems),
              const Divider(height: 32),
              Text('Détails des articles', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...items.map((item) => OrderItemCard(item: item)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, int totalItems) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Text('${order.total.toStringAsFixed(2)} €', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green.shade800)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                Text('${(item.unitPrice * item.quantity).toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
