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
      // Cas de la fermeture par planning automatique
      message = info.closureScheduleMessage ?? 'Le camion est actuellement fermé. On se retrouve très vite !';
    } else {
      // Cas de la fermeture manuelle
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
                  curve: Curves.elasticOut, // ✅ EFFET DE REBOND "FUN"
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final authService = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Pizzas'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: StreamBuilder<List<dynamic>>(
          stream: db.watchProductsAndCompanyInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            final data = snapshot.data ?? [];
            final info = data.isNotEmpty ? data[0] as CompanyInfoData? : null;
            final pizzas = data.isNotEmpty ? data[1] as List<Product> : [];
            
            final bool isAvailable = widget.ordersEnabled;

            if (info != null && !isAvailable) {
              _showClosureDialog(context, info);
            }

            if (pizzas.isEmpty) {
              return const Center(child: Text('Aucune pizza au menu pour le moment.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.70),
              itemCount: pizzas.length,
              itemBuilder: (context, index) {
                final pizza = pizzas[index];
                return ProductDisplayCard(product: pizza, isAdmin: authService.isAdmin, ordersEnabled: isAvailable);
              },
            );
          },
        ),
      ),
    );
  }
}
