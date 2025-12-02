import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart' hide User;
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/sync_service.dart';
import 'pizza_detail_screen.dart';
import 'admin_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  double _calculateFinalPrice(Product pizza) {
    if (pizza.discountPercentage != null && pizza.discountPercentage! > 0) {
      return pizza.basePrice * (1 - pizza.discountPercentage! / 100);
    }
    return pizza.basePrice;
  }

  Future<void> _syncData(BuildContext context) async {
    try {
      await Provider.of<SyncService>(context, listen: false).syncAll();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de synchronisation: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final authService = context.watch<AuthService>();
    final cartService = Provider.of<CartService>(context, listen: false);

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
              final hasDiscount = pizza.discountPercentage != null && pizza.discountPercentage! > 0;
              final finalPrice = _calculateFinalPrice(pizza);

              final nowUtc = DateTime.now().toUtc();
              final pizzaCreatedAtUtc = pizza.createdAt.toUtc();
              final bool isNew = nowUtc.difference(pizzaCreatedAtUtc).inDays <= 15;

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PizzaDetailScreen(product: pizza)),
                ),
                child: Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pizza.image != null && pizza.image!.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: pizza.image!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const SizedBox(height: 200, child: Icon(Icons.error)),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                        // ✅ CORRIGÉ: Utilisation de RichText pour un style différencié
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
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (authService.currentUser != null)
                                      IconButton(
                                        icon: const Icon(Icons.add_shopping_cart, color: Colors.orange, size: 30),
                                        onPressed: () {
                                          cartService.addToCart(pizza);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Pizza ajoutée au panier !'), duration: Duration(seconds: 1)),
                                          );
                                        },
                                      ),
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
            },
          );
        },
      ),
    );
  }
}
