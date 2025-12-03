import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'menu_screen.dart';
import 'promotions_screen.dart';
import 'about_us_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'admin_login_screen.dart';
import 'admin_screen.dart';
import 'client_area_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MenuScreen(),
    PromotionsScreen(),
    AboutUsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.local_pizza, size: 32),
        ),
        title: const Text('Pizza App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          if (authService.currentUser != null)
            IconButton(
              tooltip: 'Mon Espace Client',
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ClientAreaScreen()));
              },
            ),
          IconButton(
            tooltip: authService.currentUser == null ? 'Connexion' : 'Mon Compte / Déconnexion',
            icon: Icon(
              Icons.person,
              color: authService.currentUser == null ? Colors.grey.shade400 : Colors.greenAccent,
            ),
            onPressed: () {
              if (authService.currentUser == null) {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
              } else {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text('Connecté: ${authService.currentUser!.email}'),
                    ),
                    // ✅ CORRIGÉ: Le bouton Admin n'apparaît que si l'utilisateur est admin
                    if (authService.isAdmin)
                      const PopupMenuItem<String>(
                        value: 'admin',
                        child: ListTile(leading: Icon(Icons.admin_panel_settings), title: Text('Panneau Admin')),
                      ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: ListTile(leading: Icon(Icons.logout, color: Colors.red), title: Text('Déconnexion', style: TextStyle(color: Colors.red))),
                    ),
                  ],
                ).then((value) {
                  if (value == 'logout') {
                    authService.signOut();
                  } else if (value == 'admin') {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
                  }
                });
              }
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Promotions'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Qui sommes-nous'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
       floatingActionButton: authService.currentUser == null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                );
              },
              tooltip: 'Accès Admin',
              child: const Icon(Icons.admin_panel_settings),
            )
          : null,
    );
  }
}
