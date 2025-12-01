import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';
import '../database/app_database.dart';

class AdminMenuTab extends StatefulWidget {
  const AdminMenuTab({super.key});
  @override
  State<AdminMenuTab> createState() => _AdminMenuTabState();
}

class _AdminMenuTabState extends State<AdminMenuTab> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addPizza() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;
    setState(() => _isLoading = true);

    final adminService = Provider.of<AdminService>(context, listen: false);
    final syncService = Provider.of<SyncService>(context, listen: false);

    try {
      await adminService.addPizza(
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descriptionController.text,
      );
      
      await syncService.syncAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Pizza "${_nameController.text}" ajoutée et synchronisée !')),
        );
      }
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
    } catch (e) {
        // ✅ On s'assure que l'erreur est bien affichée dans la console et dans un SnackBar.
        debugPrint("[AdminMenuTab] Erreur attrapée: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Erreur lors de l'ajout: $e")),
          );
        }
    } finally {
      // ✅ Ce bloc s'exécutera toujours, même en cas d'erreur, débloquant l'UI.
      setState(() => _isLoading = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('➕ Nouvelle Pizza', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: Icon(Icons.local_pizza),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Prix (€)',
                      prefixIcon: Icon(Icons.euro),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _addPizza,
                      icon: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add),
                      label: Text(_isLoading ? 'Synchronisation...' : 'Ajouter & Synchroniser'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          StreamBuilder<List<Product>>(
            stream: db.watchAllProducts(),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              return Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.local_pizza, size: 48, color: Colors.red),
                      Column(
                        children: [
                          Text('$count', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                          const Text('Pizzas total', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Icon(Icons.trending_up, size: 48, color: Colors.green),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
