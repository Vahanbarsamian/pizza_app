import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'main_screen.dart';
import 'admin_orders_tab.dart';
import 'admin_main_screen.dart';
import 'admin_loyalty_tab.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const AdminOrdersTab(),
    const AdminMainScreen(),
    const AdminLoyaltyTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'store':
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
        break;
      case 'logout':
        context.read<AuthService>().signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // ✅ TITRE RESTAURÉ
        title: const Text('Panneau Administrateur'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _onMenuAction(context, value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'store',
                child: ListTile(leading: Icon(Icons.store), title: Text('Retour à la boutique')),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(leading: Icon(Icons.logout, color: Colors.red), title: Text('Déconnexion', style: TextStyle(color: Colors.red))),
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Gestion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Fidélité',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
