import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';
import 'admin_menu_tab.dart';
import 'admin_announcements_tab.dart';
import 'admin_info_tab.dart';
import 'admin_orders_tab.dart'; // ✅ IMPORTÉ

class AdminScreen extends StatefulWidget {
  final Product? productToEdit;

  const AdminScreen({super.key, this.productToEdit});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _adminTabs;

  @override
  void initState() {
    super.initState();
    _adminTabs = [
      const AdminOrdersTab(), // ✅ AJOUTÉ EN PREMIER
      AdminMenuTab(productToEdit: widget.productToEdit),
      const AdminAnnouncementsTab(),
      const AdminInfoTab(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (!authService.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panneau d\'administration'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Retour à l\'application',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _adminTabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Important pour voir tous les labels
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu & Options',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Infos Pratiques',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
