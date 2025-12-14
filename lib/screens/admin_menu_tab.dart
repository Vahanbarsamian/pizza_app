import 'package:flutter/material.dart';

import 'admin_products_tab.dart'; // ✅ AJOUTÉ: Importe le bon widget
import 'admin_options_tab.dart';

// Converti en StatefulWidget pour gérer le TabController
class AdminMenuTab extends StatefulWidget {
  const AdminMenuTab({super.key});

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
            // ✅ MODIFIÉ: Désactive le glissement pour éviter les conflits
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              // ✅ MODIFIÉ: Utilise le widget AdminProductsTab corrigé
              AdminProductsTab(),
              // Onglet 2: Gestion des ingrédients (votre bibliothèque)
              AdminOptionsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ❌ SUPPRIMÉ: Le widget _ProductsListTab interne et incorrect a été supprimé.
