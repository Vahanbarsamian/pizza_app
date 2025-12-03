import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';

class ClientAreaScreen extends StatelessWidget {
  const ClientAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final authService = context.watch<AuthService>();
    final userId = authService.currentUser?.id;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Veuillez vous connecter pour voir cet espace.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Espace Client'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Order>>(
        stream: db.watchUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Vous n\'avez pas encore de commande.'));
          }

          final orders = snapshot.data!;
          final groupedByMonth = groupBy(orders, (Order order) => DateFormat('MMMM yyyy', 'fr_FR').format(order.createdAt));

          return ListView.builder(
            itemCount: groupedByMonth.keys.length,
            itemBuilder: (context, index) {
              final month = groupedByMonth.keys.elementAt(index);
              final monthOrders = groupedByMonth[month]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      month.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                    ),
                  ),
                  ...monthOrders.map((order) => OrderCard(order: order)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final referenceText = "${order.referenceName ?? 'Commande'}${order.pickupTime != null ? ' à ${order.pickupTime}' : ''}";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(referenceText, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('le dd/MM/yyyy à HH:mm').format(order.createdAt)),
        trailing: Text(
          // ✅ CORRIGÉ: Utilise 'total' au lieu de 'totalPrice'
          '${order.total.toStringAsFixed(2)} €',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          // TODO: Naviguer vers un écran de détail de la commande
        },
      ),
    );
  }
}
