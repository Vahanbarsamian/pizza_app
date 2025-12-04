import 'package:flutter/material.dart';

import 'admin_orders_tab.dart';
import 'admin_products_tab.dart';
import 'admin_options_tab.dart';
import 'admin_info_tab.dart';
import 'admin_announcements_tab.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700, // Couleur de fond de l'AppBar
        title: const Text('Panneau Administrateur'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.orange, // Couleur du texte et de l'icône sélectionnés
          unselectedLabelColor: Colors.white, // Couleur du texte et de l'icône non sélectionnés
          indicatorColor: Colors.orange, // Couleur du petit indicateur sous l'onglet
          tabs: const [
            Tab(text: 'Commandes', icon: Icon(Icons.receipt_long)),
            Tab(text: 'Produits', icon: Icon(Icons.local_pizza)),
            Tab(text: 'Options', icon: Icon(Icons.add_shopping_cart)),
            Tab(text: 'Annonces', icon: Icon(Icons.campaign)),
            Tab(text: 'Infos Société', icon: Icon(Icons.info)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AdminOrdersTab(),
          AdminProductsTab(),
          AdminOptionsTab(),
          AdminAnnouncementsTab(),
          AdminInfoTab(),
        ],
      ),
    );
  }
}
