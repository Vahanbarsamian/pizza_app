import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'pizza_detail_screen.dart';
import 'admin_screen.dart';
import 'admin_edit_product_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<void> _refreshData() async {
    try {
      await Provider.of<SyncService>(context, listen: false).syncAll();
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

    // ✅ CORRIGÉ: Le Scaffold a été retiré.
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: StreamBuilder<List<Product>>(
        stream: db.watchAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final pizzas = snapshot.data ?? [];
          if (pizzas.isEmpty) {
            return const Center(child: Text('Aucune pizza au menu pour le moment.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70, // Ajusté pour le prix
            ),
            itemCount: pizzas.length,
            itemBuilder: (context, index) {
              final pizza = pizzas[index];
              return PizzaCard(pizza: pizza, isAdmin: authService.isAdmin);
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

  const PizzaCard({super.key, required this.pizza, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final hasImage = pizza.image != null && pizza.image!.isNotEmpty;
    final reducedPrice = pizza.basePrice * (1 - pizza.discountPercentage);
    final hasDiscount = pizza.discountPercentage > 0;
    final isNew = DateTime.now().difference(pizza.createdAt).inDays <= 15;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PizzaDetailScreen(product: pizza),
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
                    children: [
                      if (hasDiscount)
                        Text(
                          '${pizza.basePrice.toStringAsFixed(2)}€',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red, 
                            decorationThickness: 2.0,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text(
                        '${(hasDiscount ? reducedPrice : pizza.basePrice).toStringAsFixed(2)}€',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: hasDiscount ? Colors.red : Colors.black,
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
    return Positioned(
      top: 0,
      left: isTopLeft ? 0 : null,
      right: isTopLeft ? null : 0,
      child: Container(
        width: 80,
        height: 80,
        child: ClipRect(
          child: Banner(
            message: text,
            location: isTopLeft ? BannerLocation.topStart : BannerLocation.topEnd,
            color: backgroundColor,
            textStyle: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
