import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

import '../database/app_database.dart';
import '../services/sync_service.dart';
import '../services/preferences_service.dart';
import 'order_detail_screen.dart';

class AdminOrdersTab extends StatefulWidget {
  const AdminOrdersTab({super.key});

  @override
  State<AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<AdminOrdersTab> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _listenToNewOrders();
  }

  void _listenToNewOrders() {
    final syncService = context.read<SyncService>();
    final prefs = context.read<PreferencesService>();

    final ordersStream = Supabase.instance.client
        .from('orders')
        .stream(primaryKey: ['id']);

    ordersStream.listen((List<Map<String, dynamic>> data) {
      // This is a simple way to detect a new order.
      // A more robust solution would check the payload.
      if (mounted) {
        if (prefs.visualNotification) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('🔔 Nouvelle commande reçue !'),
            backgroundColor: Colors.blue,
          ));
        }
        if (prefs.soundNotification) {
          _audioPlayer.play(AssetSource('sounds/notification.mp3'));
        }
        syncService.syncAll();
      }
    });
  }

  @override
  void dispose() {
    Supabase.instance.client.removeAllChannels();
    _audioPlayer.dispose();
    super.dispose();
  }

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
          final allOrders = snapshot.data ?? [];
          if (allOrders.isEmpty) {
            return const Center(child: Text('Aucune commande à afficher.'));
          }

          final toDoOrders = allOrders.where((o) => o.status == 'À faire').toList();
          final readyOrders = allOrders.where((o) => o.status == 'Prête').toList();

          return ListView(
            children: [
              _buildSection(context, 'À PRÉPARER', toDoOrders),
              const Divider(height: 32, thickness: 1.5, indent: 16, endIndent: 16),
              _buildSection(context, 'PRÊTES', readyOrders),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Order> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 12,
                child: Text(orders.length.toString()),
              )
            ],
          ),
        ),
        if (orders.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Aucune commande dans cette section.'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text('Commande de ${order.referenceName ?? 'N/A'}'),
                  subtitle: Text('Pour ${order.pickupTime ?? 'N/A'}'),
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
                ),
              );
            },
          ),
      ],
    );
  }
}
