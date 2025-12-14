import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';
import 'admin_edit_product_screen.dart';

// On sort les méthodes logiques de la classe de widget
Future<void> _handleProductDelete(BuildContext context, Product product) async {
  final adminService = Provider.of<AdminService>(context, listen: false);
  final syncService = Provider.of<SyncService>(context, listen: false);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirmer la désactivation'),
      content: Text('Êtes-vous sûr de vouloir désactiver le produit "${product.name}" ? Il ne sera plus visible par les clients.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuler')),
        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('DÉSACTIVER', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
      ],
    ),
  ) ?? false;

  if (confirmed) {
    try {
      await adminService.deleteProduct(product.id);
      await syncService.syncAll();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit désactivé.'), backgroundColor: Colors.orange));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
    }
  }
}

Future<void> _handleProductReactivate(BuildContext context, Product product) async {
  final adminService = Provider.of<AdminService>(context, listen: false);
  final syncService = Provider.of<SyncService>(context, listen: false);
  
  try {
    await adminService.reactivateProduct(product.id);
    await syncService.syncAll();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit réactivé.'), backgroundColor: Colors.green));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
  }
}


class AdminProductsTab extends StatelessWidget {
  const AdminProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    
    return Scaffold(
      body: StreamBuilder<List<Product>>(
        // ✅ MODIFIÉ: Utilise la nouvelle requête pour voir tous les produits
        stream: db.watchAllProductsForAdmin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final bool isActive = product.isActive; // On récupère le statut

              // ✅ MODIFIÉ: Change le style et les actions en fonction du statut
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                color: isActive ? null : Colors.grey.shade300, // Fond grisé si inactif
                child: Opacity(
                  opacity: isActive ? 1.0 : 0.6, // Opacité réduite si inactif
                  child: ListTile(
                    leading: product.image != null 
                      ? SizedBox(width: 50, height: 50, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(product.image!, fit: BoxFit.cover)))
                      : const Icon(Icons.local_pizza, size: 40),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${product.basePrice.toStringAsFixed(2)} €'),
                    trailing: isActive
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Modifier',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => AdminEditProductScreen(product: product)),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.visibility_off, color: Colors.red),
                              tooltip: 'Désactiver',
                              onPressed: () => _handleProductDelete(context, product),
                            ),
                          ],
                        )
                      : IconButton(
                          icon: const Icon(Icons.undo, color: Colors.green),
                          tooltip: 'Réactiver',
                          onPressed: () => _handleProductReactivate(context, product),
                        ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Nouveau Produit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdminEditProductScreen(product: null)),
            );
          },
        ),
      ),
    );
  }
}
