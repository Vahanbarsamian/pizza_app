import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre Panier'),
      ),
      body: cartService.items.isEmpty
          ? const Center(
              child: Text('Votre panier est vide.', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: cartService.items.length,
              itemBuilder: (context, index) {
                final itemId = cartService.items.keys.elementAt(index);
                final item = cartService.items[itemId]!;

                return ListTile(
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: item.product.image != null && item.product.image!.isNotEmpty
                        ? Image.network(item.product.image!, fit: BoxFit.cover)
                        : const Icon(Icons.local_pizza),
                  ),
                  title: Text(item.product.name),
                  // ✅ CORRIGÉ: Utilise `selectedIngredients`
                  subtitle: item.selectedIngredients.isNotEmpty
                      ? Text(item.selectedIngredients.map((i) => i.name).join(', '))
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(item.finalPrice * item.quantity).toStringAsFixed(2)} €'),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => cartService.updateQuantity(itemId, item.quantity - 1),
                      ),
                      Text(item.quantity.toString(), style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => cartService.updateQuantity(itemId, item.quantity + 1),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cartService.items.isNotEmpty
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${cartService.totalPrice.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Logique de paiement à venir
                      },
                      child: const Text('Passer au paiement'),
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
