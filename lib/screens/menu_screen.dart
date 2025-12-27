import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import '../widgets/product_display_card.dart';
import 'admin_orders_tab.dart';

class MenuScreen extends StatefulWidget {
  final bool ordersEnabled; 

  const MenuScreen({super.key, required this.ordersEnabled});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isClosureDialogShown = false;

  void _showClosureDialog(BuildContext context, CompanyInfoData info) {
    if (_isClosureDialogShown) return;
    _isClosureDialogShown = true;

    final companyName = info.name ?? 'L\'établissement';
    final dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');
    String message;

    final type = info.closureMessageType != null
        ? ClosureMessageType.values.byName(info.closureMessageType!)
        : null;

    if (widget.ordersEnabled == false && type == null) {
      message = info.closureScheduleMessage ?? 'Le camion est actuellement fermé. On se retrouve très vite !';
    } else {
      switch (type) {
        case ClosureMessageType.vacation:
        case ClosureMessageType.temporary:
          final reason = type == ClosureMessageType.vacation ? "en congés" : "temporairement fermé";
          final startDate = info.closureStartDate != null ? dateFormat.format(info.closureStartDate!) : '[Date]';
          final endDate = info.closureEndDate != null ? dateFormat.format(info.closureEndDate!) : '[Date]';
          message = '$companyName sera $reason du $startDate au $endDate.';
          break;
        case ClosureMessageType.full:
          message = 'Victime de notre succès ! Nous n\'avons plus de pâte pour aujourd\'hui. Merci de votre fidélité !';
          break;
        case ClosureMessageType.custom:
          message = info.closureCustomMessage ?? 'Les commandes sont fermées.';
          break;
        default:
          message = 'Le camion est actuellement fermé.';
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (ctx) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_filled, color: Colors.orange, size: 80),
                            const SizedBox(height: 20),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white, 
                                fontSize: 24, 
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('J\'ai compris', style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ).then((_) => _isClosureDialogShown = false);
      }
    });
  }

  Future<void> _refreshData() async {
    try {
      await context.read<SyncService>().syncAll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de synchronisation: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final authService = context.watch<AuthService>();
    final userId = authService.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Pizzas'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ NOUVEAU : SECTION FAVORIS (si connecté)
              if (userId != null)
                StreamBuilder<List<Product>>(
                  stream: db.watchUserFavorites(userId),
                  builder: (context, snapshot) {
                    final favorites = snapshot.data ?? [];
                    if (favorites.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Vos coups de ❤️',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                        ),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            scrollDirection: Axis.horizontal,
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 180,
                                child: ProductDisplayCard(
                                  product: favorites[index], 
                                  isAdmin: false, 
                                  ordersEnabled: widget.ordersEnabled
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 32, indent: 16, endIndent: 16),
                      ],
                    );
                  },
                ),

              // ✅ SECTION MENU COMPLET
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  'Toute la Carte',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              StreamBuilder<List<dynamic>>(
                stream: db.watchProductsAndCompanyInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data ?? [];
                  final info = data.isNotEmpty ? data[0] as CompanyInfoData? : null;
                  final pizzas = data.isNotEmpty ? data[1] as List<Product> : [];
                  
                  if (info != null && !widget.ordersEnabled) {
                    _showClosureDialog(context, info);
                  }

                  if (pizzas.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: Text('Aucune pizza au menu pour le moment.')),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: pizzas.length,
                    itemBuilder: (context, index) {
                      final pizza = pizzas[index];
                      return ProductDisplayCard(product: pizza, isAdmin: authService.isAdmin, ordersEnabled: widget.ordersEnabled);
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
