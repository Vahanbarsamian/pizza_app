import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import 'admin_edit_product_screen.dart'; 
import 'admin_options_tab.dart';

// Converti en StatefulWidget pour gérer le TabController
class AdminMenuTab extends StatefulWidget {
  final Product? productToEdit; 

  const AdminMenuTab({super.key, this.productToEdit});

  @override
  State<AdminMenuTab> createState() => _AdminMenuTabState();
}

class _AdminMenuTabState extends State<AdminMenuTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.local_pizza), text: 'Produits'),
            Tab(icon: Icon(Icons.add_task), text: 'Ingrédients'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // Onglet 1: Gestion des produits
              _ProductsListTab(),
              // Onglet 2: Gestion des ingrédients (votre bibliothèque)
              AdminOptionsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget séparé pour la liste des produits
class _ProductsListTab extends StatelessWidget {
  const _ProductsListTab();

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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AdminEditProductScreen(product: product)),
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
