import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import 'order_detail_screen.dart';

enum OrderFilter { all, week, month, year }

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OrderFilter _activeFilter = OrderFilter.all;

  List<OrderWithStatus> _filterOrders(List<OrderWithStatus> orders) {
    final now = DateTime.now();
    switch (_activeFilter) {
      case OrderFilter.week:
        return orders.where((o) => now.difference(o.order.createdAt).inDays <= 7).toList();
      case OrderFilter.month:
        return orders.where((o) => now.difference(o.order.createdAt).inDays <= 30).toList();
      case OrderFilter.year:
        return orders.where((o) => now.difference(o.order.createdAt).inDays <= 365).toList();
      case OrderFilter.all:
      default:
        return orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final authService = context.watch<AuthService>();
    final userId = authService.currentUser?.id;

    if (userId == null) {
      return const Center(child: Text('Veuillez vous connecter pour voir cet historique.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes'),
      ),
      body: StreamBuilder<List<OrderWithStatus>>(
        stream: db.watchUserOrdersWithStatus(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Vous n\'avez pas encore passé de commande.'));
          }

          final allOrders = snapshot.data!;
          final filteredOrders = _filterOrders(allOrders);

          return Column(
            children: [
              _buildFilterChips(),
              _buildPizzaCounter(db, filteredOrders),
              const Divider(),
              Expanded(
                child: filteredOrders.isEmpty
                    ? const Center(child: Text('Aucune commande pour cette période.'))
                    : _buildGroupedList(filteredOrders),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        alignment: WrapAlignment.center,
        children: OrderFilter.values.map((filter) {
          return ChoiceChip(
            label: Text(filter.name.substring(0, 1).toUpperCase() + filter.name.substring(1)),
            selected: _activeFilter == filter,
            selectedColor: const Color(0xFFE6E6FA), // Mauve pâle
            onSelected: (selected) {
              if (selected) {
                setState(() => _activeFilter = filter);
              }
            },
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildPizzaCounter(AppDatabase db, List<OrderWithStatus> orders) {
    if (orders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('0 pizzas commandées', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );
    }

    final orderIds = orders.map((o) => o.order.id).toList();
    final futureItemCount = db.transaction(() async {
      int count = 0;
      for (var id in orderIds) {
        final items = await db.getOrderItems(id);
        count += items.fold<int>(0, (sum, item) => sum + item.quantity);
      }
      return count;
    });

    return FutureBuilder<int>(
      future: futureItemCount,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text('$count pizzas commandées', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  Widget _buildGroupedList(List<OrderWithStatus> orders) {
    final groupedByMonth = groupBy(orders, (OrderWithStatus ows) => DateFormat('MMMM yyyy', 'fr_FR').format(ows.order.createdAt));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: groupedByMonth.keys.length,
      itemBuilder: (context, index) {
        final month = groupedByMonth.keys.elementAt(index);
        final monthOrders = groupedByMonth[month]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Text(
                month.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
              ),
            ),
            ...monthOrders.map((ows) => OrderCard(order: ows.order)),
          ],
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final referenceText = "${order.referenceName ?? 'Commande'}${order.pickupTime != null ? ' pour ${order.pickupTime}' : ''}";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        title: Text(referenceText, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('le dd/MM/yyyy à HH:mm', 'fr_FR').format(order.createdAt)),
        trailing: Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 16),
            children: [
              TextSpan(text: order.total.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' €', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OrderDetailScreen(order: order, status: 'Terminée'), // Le statut ici est arbitraire car non utilisé dans la logique de l'écran de détail pour l'user
          ));
        },
      ),
    );
  }
}
