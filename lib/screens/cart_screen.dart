import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // On utilise un Consumer pour que l'écran se reconstruise à chaque changement du panier
    return Consumer<CartService>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mon Panier'),
            actions: [
              // Bouton pour vider le panier
              if (cart.items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  tooltip: 'Vider le panier',
                  onPressed: () => cart.clearCart(),
                ),
            ],
          ),
          body: cart.items.isEmpty
              ? const Center(
                  child: Text('Votre panier est vide.', style: TextStyle(fontSize: 18)),
                )
              : ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(cartItem.quantity.toString()),
                        ),
                        title: Text(cartItem.product.name),
                        subtitle: Text('€${cartItem.subtotal.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => cart.removeFromCart(cartItem),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () => cart.addToCart(cartItem.product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          // Affiche le total et le bouton de commande en bas de l'écran
          bottomNavigationBar: cart.items.isEmpty
              ? null
              : BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total: €${cart.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Logique pour passer la commande à implémenter ici
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Commande passée (simulation) !')),
                            );
                            cart.clearCart();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text('Valider'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
