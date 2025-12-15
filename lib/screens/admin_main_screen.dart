import 'package:flutter/material.dart';

import 'admin_menu_tab.dart';
import 'admin_announcements_tab.dart';
import 'admin_info_tab.dart';
import 'admin_statistics_tab.dart'; // ✅ AJOUT

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  // ✅ AJOUT
  static const List<Widget> _widgetOptions = <Widget>[
    AdminMenuTab(),
    AdminAnnouncementsTab(),
    AdminStatisticsTab(), // Onglet Statistiques
    AdminInfoTab(),
  ];

  // ✅ AJOUT
  static const List<String> _titles = <String>[
    'Admin / Menu',
    'Admin / Annonces',
    'Admin / Statistiques',
    'Admin / Infos',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles.elementAt(_selectedIndex)),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      // ✅ AJOUT
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
            icon: Icon(Icons.bar_chart), // Icône pour les stats
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Infos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Important pour voir tous les labels
      ),
    );
  }
}
