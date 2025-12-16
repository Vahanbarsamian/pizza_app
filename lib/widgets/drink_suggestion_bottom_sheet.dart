import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // ✅ AJOUT

import '../database/app_database.dart';
import '../services/cart_service.dart';

class DrinkSuggestionBottomSheet extends StatelessWidget {
  const DrinkSuggestionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final cartService = context.watch<CartService>();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Désirez-vous rajouter une boisson ?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: StreamBuilder<List<Product>>(
              stream: db.watchAllDrinks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final drinks = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    final drink = drinks[index];
                    final bool isSelected = cartService.items.values.any((item) => item.product.id == drink.id);

                    return SizedBox(
                      width: 120,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? Colors.orange : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (isSelected) {
                              final itemInCart = cartService.items.values.firstWhere((item) => item.product.id == drink.id);
                              cartService.removeItem(itemInCart.uniqueId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${drink.name} retiré du panier.'), backgroundColor: Colors.red, duration: const Duration(seconds: 1)),
                              );
                            } else {
                              cartService.addToCart(drink);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${drink.name} ajouté au panier !'), backgroundColor: Colors.green, duration: const Duration(seconds: 1)),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ✅ MODIFIÉ: Utilisation de la nouvelle icône
                              FaIcon(FontAwesomeIcons.bottleWater, size: 40, color: isSelected ? Colors.orange : Colors.grey.shade700),
                              const SizedBox(height: 8),
                              Text(drink.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${drink.basePrice.toStringAsFixed(2)} €'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continuer vers le panier'),
            ),
          ),
        ],
      ),
    );
  }
}
