import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../widgets/drink_suggestion_bottom_sheet.dart'; // ✅ AJOUT
import 'menu_screen.dart';
import 'promotions_screen.dart';
import 'about_us_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'admin_screen.dart';
import 'client_area_screen.dart';
import 'public_reviews_screen.dart';
import 'drinks_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MenuScreen(),
    DrinksPage(),
    PromotionsScreen(),
    PublicReviewsScreen(),
    AboutUsScreen(),
  ];

  static const List<String> _appBarTitles = <String>[
    'Menu',
    'Nos Boissons',
    'Promotions & Annonces',
    'Avis des Clients',
    'À Propos',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✅ CORRIGÉ: Logique de suggestion de boissons
  void _handleCartPressed(BuildContext context) async {
    final cartService = context.read<CartService>();
    final navigator = Navigator.of(context);

    // ✅ CORRIGÉ: Utilise .values.any sur la map
    final bool shouldSuggestDrinks = cartService.items.isEmpty || !cartService.items.values.any((item) => item.product.isDrink);

    if (shouldSuggestDrinks) {
      await showModalBottomSheet(
        context: context,
        builder: (ctx) => const DrinkSuggestionBottomSheet(),
        isScrollControlled: true,
      );
      navigator.push(MaterialPageRoute(builder: (context) => const CartScreen()));
    } else {
      navigator.push(MaterialPageRoute(builder: (context) => const CartScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final cartService = context.watch<CartService>();
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        leading: StreamBuilder<CompanyInfoData?>(
          stream: db.watchCompanyInfo(),
          builder: (context, snapshot) {
            final companyName = snapshot.data?.name ?? 'Pizza App';
            return Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Center(child: Text(companyName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            );
          },
        ),
        leadingWidth: 150,
        title: Text(_appBarTitles[_selectedIndex]),
        centerTitle: true,
        actions: <Widget>[
          Badge(
            label: Text(
              cartService.itemCount.toString(), 
              style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            isLabelVisible: cartService.itemCount > 0,
            backgroundColor: Colors.green,
            alignment: AlignmentDirectional.bottomEnd,
            offset: const Offset(-8, -16),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            largeSize: 18,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => _handleCartPressed(context),
            ),
          ),
          if (authService.currentUser != null && !authService.isAdmin)
            IconButton(
              tooltip: 'Mon Espace Client',
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ClientAreaScreen())),
            ),
          IconButton(
            tooltip: authService.currentUser == null ? 'Connexion' : 'Mon Compte / Déconnexion',
            icon: Icon(Icons.person, color: authService.currentUser == null ? Colors.grey.shade400 : Colors.greenAccent),
            onPressed: () {
              if (authService.currentUser == null) {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
              } else {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(enabled: false, child: Text('Connecté: ${authService.currentUser!.email}')),
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
                  if (value == 'logout') authService.signOut();
                  else if (value == 'admin') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
                });
              }
            },
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Pizzas'),
          BottomNavigationBarItem(icon: Icon(Icons.local_bar), label: 'Boissons'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Promos'),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: 'Avis'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
       floatingActionButton: authService.isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminScreen())),
              tooltip: 'Retour au Panneau Admin',
              child: const Icon(Icons.admin_panel_settings),
            )
          : null,
    );
  }
}
