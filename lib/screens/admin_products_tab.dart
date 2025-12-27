import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';
import 'admin_edit_product_screen.dart';

class AdminProductsTab extends StatefulWidget {
  const AdminProductsTab({super.key});

  @override
  State<AdminProductsTab> createState() => _AdminProductsTabState();
}

class _AdminProductsTabState extends State<AdminProductsTab> {
  bool _isAscending = true;

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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit désactivé.'), backgroundColor: Colors.orange));
      } catch (e) {
        if (!mounted) return;
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit réactivé.'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
    }
  }

  // ✅ NOUVEAU : Gérer la rupture de stock
  Future<void> _toggleOutOfStock(Product product, bool value) async {
    final adminService = Provider.of<AdminService>(context, listen: false);
    final syncService = Provider.of<SyncService>(context, listen: false);
    try {
      await adminService.toggleProductOutOfStock(product.id, value);
      await syncService.syncAll();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur stock: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Grouper par : Type (Pizza > Boisson)', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                IconButton(
                  icon: Icon(_isAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined),
                  tooltip: _isAscending ? 'Trier Z-A' : 'Trier A-Z',
                  onPressed: () => setState(() => _isAscending = !_isAscending),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: db.watchAllProductsForAdmin(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                var products = snapshot.data!;

                products.sort((a, b) {
                  if (a.isDrink != b.isDrink) {
                    return a.isDrink ? 1 : -1;
                  }
                  return _isAscending 
                    ? a.name.compareTo(b.name) 
                    : b.name.compareTo(a.name);
                });

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final bool isActive = product.isActive;
                    final bool isOutOfStock = product.isOutOfStock;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      // ✅ Couleur différente si épuisé
                      color: !isActive ? Colors.grey.shade300 : (isOutOfStock ? Colors.red.shade50 : null),
                      child: Opacity(
                        opacity: isActive ? 1.0 : 0.6,
                        child: ListTile(
                          leading: product.image != null && product.image!.isNotEmpty
                            ? SizedBox(width: 50, height: 50, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(product.image!, fit: BoxFit.cover)))
                            : Icon(
                                product.isDrink ? Icons.local_drink_outlined : Icons.local_pizza_outlined,
                                size: 36,
                                color: Colors.grey.shade700,
                              ),
                          title: Row(
                            children: [
                              Expanded(child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                              if (isOutOfStock)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('ÉPUISÉ', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          subtitle: Text('${product.basePrice.toStringAsFixed(2)} €'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ✅ NOUVEAU: Interrupteur Rupture de stock
                              if (isActive)
                                Switch(
                                  value: isOutOfStock,
                                  onChanged: (val) => _toggleOutOfStock(product, val),
                                  activeColor: Colors.red,
                                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states) => isOutOfStock ? const Icon(Icons.block, color: Colors.white) : null),
                                ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminEditProductScreen(product: product))),
                              ),
                              if (isActive)
                                IconButton(
                                  icon: const Icon(Icons.visibility_off, color: Colors.red),
                                  onPressed: () => _handleProductDelete(context, product),
                                )
                              else
                                IconButton(
                                  icon: const Icon(Icons.undo, color: Colors.green),
                                  onPressed: () => _handleProductReactivate(context, product),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
