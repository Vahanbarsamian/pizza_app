import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import 'admin_edit_product_screen.dart'; // ✅ Import de la nouvelle page

class AdminMenuTab extends StatelessWidget {
  const AdminMenuTab({super.key, productToEdit});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<Product>>(
        stream: db.watchAllProducts(),
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('${product.basePrice.toStringAsFixed(2)} €'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // TODO: Naviguer vers AdminEditProductScreen en passant le produit
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AdminEditProductScreen()),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigue vers l'écran d'édition en mode "création"
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminEditProductScreen()),
          );
        },
        label: const Text('Ajouter une Pizza'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
