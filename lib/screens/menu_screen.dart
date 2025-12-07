import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'pizza_detail_screen.dart';
import 'admin_screen.dart';
import 'admin_edit_product_screen.dart';
import 'admin_orders_tab.dart'; // For ClosureMessageType enum

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isClosureDialogShown = false;

  Future<void> _showClosureDialog(CompanyInfoData info) async {
    if (_isClosureDialogShown) return;
    setState(() {
      _isClosureDialogShown = true;
    });

    String title = 'Commandes fermées';
    String message = 'Nous ne prenons plus de commandes pour le moment.';
    final dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

    if (info.closureMessageType != null) {
      try {
        final type = ClosureMessageType.values.byName(info.closureMessageType!);
        switch (type) {
          case ClosureMessageType.vacation:
            title = 'En Congés';
            message = 'Nous sommes actuellement en congés.';
            if (info.closureStartDate != null && info.closureEndDate != null) {
              message += '\nRetour le ${dateFormat.format(info.closureEndDate!.add(const Duration(days: 1)))}';
            }
            break;
          case ClosureMessageType.temporary:
            title = 'Fermeture Temporaire';
            message = 'Le service de commande est temporairement indisponible.';
            if (info.closureStartDate != null && info.closureEndDate != null) {
              message += '\nDu ${dateFormat.format(info.closureStartDate!)} au ${dateFormat.format(info.closureEndDate!)}.';
            }
            break;
          case ClosureMessageType.full:
            title = 'Complet';
            message = 'Nous sommes complets pour ce soir, nous ne pouvons plus prendre de commandes.';
            break;
          case ClosureMessageType.custom: // ✅ CAS MANQUANT AJOUTÉ
            title = 'Information';
            message = info.closureCustomMessage ?? 'Une maintenance est en cours.';
            break;
        }
      } catch (e) { /* Enum value might not exist, use default message */ }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
            ],
          ),
        );
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
            _showClosureDialog(info);
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
