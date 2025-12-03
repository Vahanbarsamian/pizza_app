import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart' hide User;
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/sync_service.dart';
import 'pizza_detail_screen.dart';
import 'admin_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<void> _syncData(BuildContext context) async {
    try {
      await Provider.of<SyncService>(context, listen: false).syncAll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de synchronisation: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return RefreshIndicator(
      onRefresh: () => _syncData(context),
      child: StreamBuilder<List<Product>>(
        stream: db.watchAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('Aucune pizza. Tirez pour rafraîchir.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final pizza = products[index];
              return PizzaCard(pizza: pizza);
            },
          );
        },
      ),
    );
  }
}

class PizzaCard extends StatefulWidget {
  final Product pizza;

  const PizzaCard({super.key, required this.pizza});

  @override
  State<PizzaCard> createState() => _PizzaCardState();
}

class _PizzaCardState extends State<PizzaCard> {
  double _elevation = 8.0;

  double _calculateFinalPrice(Product pizza) {
    if (pizza.discountPercentage != null && pizza.discountPercentage! > 0) {
      return pizza.basePrice * (1 - pizza.discountPercentage! / 100);
    }
    return pizza.basePrice;
  }

  @override
  Widget build(BuildContext context) {
    final pizza = widget.pizza;
    final hasImage = pizza.image != null && pizza.image!.isNotEmpty;
    final hasDiscount = pizza.discountPercentage != null && pizza.discountPercentage! > 0;
    final finalPrice = _calculateFinalPrice(pizza);
    final isNew = DateTime.now().toUtc().difference(pizza.createdAt.toUtc()).inDays <= 15;

    final authService = context.watch<AuthService>();

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PizzaDetailScreen(product: pizza)),
      ),
      onHover: (isHovering) {
        setState(() {
          _elevation = isHovering ? 16.0 : 8.0;
        });
      },
      splashColor: Colors.orange.withOpacity(0.3),
      hoverColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: _elevation,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  CachedNetworkImage(
                    imageUrl: pizza.image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const SizedBox(height: 200, child: Icon(Icons.error)),
                  ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, hasImage ? 12 : 32, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pizza.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (pizza.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: Text(
                            pizza.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasDiscount)
                                Text(
                                  '${pizza.basePrice.toStringAsFixed(2)} €',
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.red,
                                    decorationThickness: 2.5,
                                    color: Colors.grey.shade700,
                                  ),
                                ),                              
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: hasDiscount ? Colors.green.shade700 : Theme.of(context).colorScheme.onSurface,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: '${finalPrice.toStringAsFixed(2)} '),
                                    TextSpan(
                                      text: '€ TTC',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // ✅ CORRIGÉ: Affiche l'icône "info" uniquement pour les non-admins
                          if (!authService.isAdmin)
                            Icon(Icons.info_outline, size: 28, color: Colors.grey.shade400),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isNew)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  ),
                  child: const Text('NOUVEAU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ),
            if (hasDiscount)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  child: const Text('PROMO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ),
            if (authService.isAdmin)
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.edit, size: 20, color: Colors.orange),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AdminScreen(productToEdit: pizza)),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
