import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'pizza_detail_screen.dart';
import 'admin_screen.dart';
import 'admin_edit_product_screen.dart';
import 'admin_orders_tab.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

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

    switch (type) {
      case ClosureMessageType.vacation:
      case ClosureMessageType.temporary:
        final reason = type == ClosureMessageType.vacation ? "en congés" : "temporairement fermé";
        final startDate = info.closureStartDate != null ? dateFormat.format(info.closureStartDate!) : '[Date de début]';
        final endDate = info.closureEndDate != null ? dateFormat.format(info.closureEndDate!) : '[Date de fin]';
        message = '$companyName informe son aimable clientèle qu\'il sera $reason pour la période du $startDate au $endDate.\n\nOn espère vous retrouver très vite !\nL\'équipe $companyName';
        break;
      case ClosureMessageType.full:
        message = '$companyName vous informe qu\'ayant épuisé la totalité de la pâte, nous ne sommes plus en mesure d\'honorer vos commandes.\n\nComptant sur votre compréhension, nous vous souhaitons une agréable journée.\nL\'équipe $companyName';
        break;
      case ClosureMessageType.custom:
        message = info.closureCustomMessage ?? 'Les commandes sont actuellement fermées.';
        break;
      default:
        message = 'Les commandes sont actuellement fermées pour une raison non spécifiée.';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.7), // Fond plus sombre
          builder: (ctx) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ],
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

    return RefreshIndicator(
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
          final ordersEnabled = info?.ordersEnabled ?? true;

          if (info != null && !ordersEnabled) {
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
              return PizzaCard(pizza: pizza, isAdmin: authService.isAdmin, ordersEnabled: ordersEnabled);
            },
          );
        },
      ),
    );
  }
}

class PizzaCard extends StatelessWidget {
  final Product pizza;
  final bool isAdmin;
  final bool ordersEnabled;

  const PizzaCard({super.key, required this.pizza, required this.isAdmin, required this.ordersEnabled});

  @override
  Widget build(BuildContext context) {
    final hasImage = pizza.image != null && pizza.image!.isNotEmpty;
    final hasDiscount = pizza.discountPercentage > 0;
    final reducedPrice = pizza.basePrice * (1 - pizza.discountPercentage);
    final isNew = DateTime.now().difference(pizza.createdAt).inDays <= 15;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PizzaDetailScreen(product: pizza, ordersEnabled: ordersEnabled),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  hasImage
                      ? CachedNetworkImage(
                          imageUrl: pizza.image!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.local_pizza_outlined, size: 50, color: Colors.grey),
                        ),
                  if (isAdmin)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminEditProductScreen(product: pizza)));
                        },
                      ),
                    ),
                  if (hasDiscount)
                    _buildBanner('PROMO', Colors.amber, Colors.black, Alignment.topLeft),
                  if (isNew)
                    _buildBanner('NOUVEAU', Colors.blue, Colors.white, Alignment.topRight),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pizza.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (hasDiscount)
                        Text(
                          '${pizza.basePrice.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: hasDiscount ? Colors.red : Colors.black,
                          ),
                          children: [
                            TextSpan(text: (hasDiscount ? reducedPrice : pizza.basePrice).toStringAsFixed(2)),
                            const TextSpan(
                              text: ' € TTC',
                              style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(String text, Color backgroundColor, Color textColor, Alignment alignment) {
    final isTopLeft = alignment == Alignment.topLeft;
    return Banner(
      message: text,
      location: isTopLeft ? BannerLocation.topStart : BannerLocation.topEnd,
      color: backgroundColor,
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}
