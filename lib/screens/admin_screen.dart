import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'admin_menu_tab.dart';
import 'admin_announcements_tab.dart';
import 'admin_info_tab.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AdminMenuTab(),
    AdminAnnouncementsTab(),
    AdminInfoTab(),
  ];

  static const List<String> _titles = <String>[
    'Admin / Menu',
    'Admin / Annonces',
    'Admin / Infos',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles.elementAt(_selectedIndex)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour au site',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // ✅ CORRIGÉ: Remplace l'icône de déconnexion par l'icône utilisateur verte.
          IconButton(
            icon: const Icon(Icons.person, color: Colors.lightGreenAccent),
            tooltip: 'Déconnexion complète',
            onPressed: () {
              authService.signOut();
              // Navigue vers la page d'accueil après la déconnexion
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Infos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
