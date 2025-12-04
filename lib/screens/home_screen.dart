import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart' hide User;
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/sync_service.dart';
import 'pizza_detail_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  double _calculateFinalPrice(Product pizza) {
    if (pizza.hasGlobalDiscount && pizza.discountPercentage != null) {
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
    final authService = Provider.of<AuthService>(context);
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
              final hasDiscount = pizza.hasGlobalDiscount &&
                  pizza.discountPercentage != null &&
                  pizza.discountPercentage! > 0;
              final finalPrice = _calculateFinalPrice(pizza);

              // ✅ NOUVEAU: Logique pour déterminer si un produit est nouveau
              final bool isNew = DateTime.now().difference(pizza.createdAt).inDays <= 15;

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => PizzaDetailScreen(product: pizza)),
                ),
                child: Stack(
                  children: [
                    Card(
                      elevation: 4,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: pizza.image != null
                                ? Image.network(
                                    pizza.image!,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.local_pizza, size: 50, color: Colors.grey),
                                  )
                                : const Icon(Icons.local_pizza, size: 50, color: Colors.grey),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pizza.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  if (pizza.description != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        pizza.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (hasDiscount)
                                            Text(
                                              '${pizza.basePrice.toStringAsFixed(2)} € TTC',
                                              style: TextStyle(
                                                fontSize: 14,
                                                decoration: TextDecoration.lineThrough,
                                                decorationColor: Colors.red,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          Text(
                                            '${finalPrice.toStringAsFixed(2)} € TTC',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: hasDiscount ? Colors.green.shade700 : Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      StreamBuilder<User?>(
                                        stream: authService.authStateChanges,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return IconButton(
                                              icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
                                              onPressed: () {
                                                cartService.addToCart(pizza);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Pizza ajoutée au panier !'),
                                                    duration: Duration(seconds: 1),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // ✅ NOUVEAU: Affiche le bandeau "Nouveau" si nécessaire
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
                          child: const Text(
                            'NOUVEAU',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
