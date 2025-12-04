import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import 'order_detail_screen.dart';

class AdminOrdersTab extends StatelessWidget {
  const AdminOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<Order>>(
        stream: db.watchAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('Aucune commande à afficher.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Commande de ${order.referenceName ?? 'N/A'}'),
                subtitle: Text('Le ${DateFormat('dd/MM/yyyy à HH:mm').format(order.createdAt)}'),
                trailing: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(text: order.total.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(order: order),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
