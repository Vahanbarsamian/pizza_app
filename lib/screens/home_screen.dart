import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../services/sync_service.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SyncService _syncService;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    // Récupère le service sans écouter les changements
    _syncService = Provider.of<SyncService>(context, listen: false);
    // Lance la première synchronisation
    _syncProducts();
  }

  Future<void> _syncProducts() async {
    setState(() => _isSyncing = true);
    try {
      await _syncService.syncProducts();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de synchronisation: $e')),
        );
      }
    }
    if (mounted) {
      setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🍕 PizzaApp'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white))),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _syncProducts, // Le pull-to-refresh lance une nouvelle synchro
        child: StreamBuilder<List<Product>>(
          stream: db.watchAllProducts(),
          builder: (context, snapshot) {
            final products = snapshot.data ?? [];

            if (snapshot.connectionState == ConnectionState.waiting && products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            if (products.isEmpty && !_isSyncing) {
              return const Center(
                  child: Text('Aucune pizza. Tirez pour rafraîchir.'));
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final pizza = products[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: pizza.image != null
                        ? Image.network(
                            pizza.image!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.local_pizza, color: Colors.orange),
                          )
                        : const Icon(Icons.local_pizza, color: Colors.orange),
                    title: Text(pizza.name),
                    subtitle: Text('€${(pizza.basePrice).toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.add_shopping_cart,
                        color: Colors.orange),
                    onTap: () => _showPizzaDetails(context, pizza),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminScreen()),
        ),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.admin_panel_settings, color: Colors.white),
      ),
    );
  }

  void _showPizzaDetails(BuildContext context, Product pizza) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pizza.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pizza.image != null) ...[
              Image.network(pizza.image!, height: 150, fit: BoxFit.cover),
              const SizedBox(height: 10),
            ],
            Text('Prix: €${(pizza.basePrice).toStringAsFixed(2)}'),
            Text('Catégorie: ${pizza.category ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
