import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart' hide User;
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import 'login_screen.dart';
import 'cart_screen.dart';
import 'admin_screen.dart';
import 'menu_screen.dart';
import 'promotions_screen.dart';
import 'about_us_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MenuScreen(),
    PromotionsScreen(),
    AboutUsScreen(),
  ];

  // ✅ CORRIGÉ: L'emoji a été retiré pour être remplacé par une icône.
  static const List<String> _titles = <String>[
    '🍕 Menu',
    '🎉 Promotions',
    'Qui sommes-nous',
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
        // ✅ CORRIGÉ: Le titre affiche une icône personnalisée pour la page "Qui sommes-nous"
        title: _selectedIndex == 2
            ? Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue.shade800,
                    child: const Icon(Icons.info_outline, color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 8),
                  Text(_titles[_selectedIndex]),
                ],
              )
            : Text(_titles[_selectedIndex]),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CartService>(
            builder: (context, cart, child) => Badge(
              label: Text('${cart.items.length}'),
              isLabelVisible: cart.items.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Voir le panier',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
            ),
          ),
          authService.currentUser == null
              ? IconButton(
                  icon: Icon(Icons.person, color: Colors.white.withOpacity(0.7)),
                  tooltip: 'Connexion / Inscription',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.person, color: Colors.lightGreenAccent),
                  tooltip: 'Connecté: ${authService.currentUser!.email}\n(Cliquer pour se déconnecter)',
                  onPressed: () => authService.signOut(),
                ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: authService.isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              ),
              backgroundColor: Colors.red,
              tooltip: 'Panneau d\'administration',
              child: const Icon(Icons.admin_panel_settings, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Promotions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Qui sommes-nous',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}
