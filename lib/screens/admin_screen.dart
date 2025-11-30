import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/admin_service.dart';
import '../database/app_database.dart';

// NOTE: Les imports pour admin_auth et le modèle admin sont conservés
// en supposant qu'ils sont toujours nécessaires pour la logique d'authentification.
import '../services/admin_auth.dart';
import '../models/admin.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  // La méthode accède maintenant au service via le Provider
  Future<void> _addPizza(AdminService adminService) async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;
    setState(() => _isLoading = true);

    await adminService.addPizza(
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
    );

    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Pizza "${_nameController.text}" ajoutée !')),
      );
    }
    _nameController.clear();
    _priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Récupère l'AdminService et la DB depuis le Provider
    final adminService = Provider.of<AdminService>(context);
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('🔧 Admin ${AdminAuthService.currentUser?.email ?? ''}'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // La logique d'authentification est conservée
              AdminAuthService.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('➕ Nouvelle Pizza',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Prix (€)',
                        prefixIcon: Icon(Icons.euro),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _addPizza(adminService),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white)))
                            : const Icon(Icons.add),
                        label: Text(_isLoading ? 'Ajout...' : '➕ Ajouter'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // ✅ Le compteur de pizzas est maintenant réactif en temps réel
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
                            Text('$count',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home),
              label: const Text('🏠 Menu Client'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
