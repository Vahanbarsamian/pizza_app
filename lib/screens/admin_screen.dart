import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';
import 'admin_menu_tab.dart';
import 'admin_announcements_tab.dart';
import 'admin_info_tab.dart';

class AdminScreen extends StatefulWidget {
  final Product? productToEdit;
  final Announcement? announcementToEdit;

  const AdminScreen({super.key, this.productToEdit, this.announcementToEdit});

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
      AdminMenuTab(productToEdit: widget.productToEdit),
      AdminAnnouncementsTab(announcementToEdit: widget.announcementToEdit),
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

    // Redirige si l'utilisateur n'est pas admin
    if (!authService.isAdmin) {
      // Utilise un post-frame callback pour ne pas perturber le build
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
        // ✅ CORRIGÉ: Style amélioré pour l'en-tête admin
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
        items: const <BottomNavigationBarItem>[
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
