import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rxdart/rxdart.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/biometric_service.dart';
import '../services/preferences_service.dart';
import '../widgets/drink_suggestion_bottom_sheet.dart';
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

  Stream<bool> _effectiveOpenStream(AppDatabase db) {
    return Rx.combineLatest2(
      db.watchCompanyInfo(),
      db.watchIsStoreCurrentlyOpen(),
      (CompanyInfoData? info, bool isScheduleOpen) {
        final bool manualOpen = info?.ordersEnabled ?? true;
        return manualOpen && isScheduleOpen;
      },
    );
  }

  // ✅ NOUVEAU: Détermine si on doit proposer le bouton de thème
  bool _shouldShowThemeToggle() {
    final now = DateTime.now();
    // Propose l'icône entre 18h et 6h du matin
    return now.hour >= 18 || now.hour < 6;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _navigateToAdmin(BuildContext context) async {
    final prefs = context.read<PreferencesService>();
    final bioService = context.read<BiometricService>();

    if (prefs.biometricEnabled) {
      final bool canCheck = await bioService.canCheckBiometrics();
      if (canCheck) {
        final bool authenticated = await bioService.authenticate();
        if (!authenticated) return;
      }
    }

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
    }
  }

  void _handleCartPressed(BuildContext context) async {
    final cartService = context.read<CartService>();
    final navigator = Navigator.of(context);

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
    final prefs = context.watch<PreferencesService>(); // ✅ Écoute des prefs

    return StreamBuilder<bool>(
      stream: _effectiveOpenStream(db),
      builder: (context, openSnapshot) {
        final bool isCurrentlyTakingOrders = openSnapshot.data ?? true;

        final List<Widget> widgetOptions = <Widget>[
          MenuScreen(ordersEnabled: isCurrentlyTakingOrders),
          DrinksPage(ordersEnabled: isCurrentlyTakingOrders),
          const PromotionsScreen(),
          const PublicReviewsScreen(),
          const AboutUsScreen(),
        ];

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 16.0,
            toolbarHeight: 100, 
            title: StreamBuilder<CompanyInfoData?>(
              stream: db.watchCompanyInfo(),
              builder: (context, snapshot) {
                final companyInfo = snapshot.data;
                final hasLogo = companyInfo?.logoUrl != null && companyInfo!.logoUrl!.isNotEmpty;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyInfo?.name ?? 'Pizza App',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (hasLogo)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          height: 60,
                          width: 200,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: companyInfo!.logoUrl!,
                                fit: BoxFit.contain,
                                alignment: Alignment.centerLeft,
                                placeholder: (context, url) => const SizedBox(height: 2, width: 20, child: LinearProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0),
                                highlightColor: Colors.white.withOpacity(0.5),
                                period: const Duration(seconds: 5),
                                child: CachedNetworkImage(
                                  imageUrl: companyInfo.logoUrl!,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            actions: <Widget>[
              // ✅ NOUVEAU: Bouton de thème contextuel (apparaît le soir)
              if (_shouldShowThemeToggle())
                IconButton(
                  icon: Icon(
                    prefs.themeMode == ThemeMode.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    color: Colors.amber,
                  ),
                  tooltip: 'Changer le thème',
                  onPressed: () => prefs.toggleTheme(),
                ),

              if (!isCurrentlyTakingOrders)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      'FERMÉ', 
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
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
                      else if (value == 'admin') _navigateToAdmin(context);
                    });
                  }
                },
              ),
            ],
          ),
          body: Center(child: widgetOptions.elementAt(_selectedIndex)),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Pizzas'),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bottleWater),
                label: 'Boissons',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Promos'),
              BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: 'Avis'),
              BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
           floatingActionButton: authService.isAdmin
              ? FloatingActionButton(
                  onPressed: () => _navigateToAdmin(context),
                  tooltip: 'Retour au Panneau Admin',
                  child: const Icon(Icons.admin_panel_settings),
                )
              : null,
        );
      }
    );
  }
}
