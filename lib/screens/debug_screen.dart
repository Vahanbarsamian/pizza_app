import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../database/product.dart';
import '../services/sync_service.dart';
import '../services/notification_service.dart';

class DebugScreen extends StatefulWidget {
  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  bool _isSyncing = false;

  Future<void> _syncData() async {
    setState(() => _isSyncing = true);
    final db = Provider.of<AppDatabase>(context, listen: false);
    final syncService = SyncService(db: db);
    await syncService.syncAll();
    setState(() => _isSyncing = false);
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍕 Pizza App - DEBUG'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.music_note),
            onPressed: () => NotificationService.playNotification(),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSyncing ? null : _syncData,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: _isSyncing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('SYNC SUPABASE', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => NotificationService.playNotification(),
                    icon: const Icon(Icons.music_note),
                    label: const Text('🔊 SON'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: db.watchAllProducts(),
              builder: (context, snapshot) {
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return const Center(child: Text('Aucun produit - Cliquez SYNC'));
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return Card(
                      child: ListTile(
                        title: Text(p.name),
                        subtitle: Text('${p.basePrice.toStringAsFixed(1)} €'),
                        trailing: const Icon(Icons.restaurant),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
