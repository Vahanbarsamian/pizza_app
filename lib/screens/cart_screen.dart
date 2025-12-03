import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartService>();
    final orderService = context.read<OrderService>();
    final user = context.read<AuthService>().currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur: Utilisateur non connecté.')));
      return;
    }

    final orderDetails = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        final nameController = TextEditingController(text: cart.temporaryReferenceName);
        final timeController = TextEditingController(text: cart.temporaryPickupTime);
        return AlertDialog(
          title: const Text('Finaliser la commande'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom pour la commande', hintText: 'Ex: Paul'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Heure de retrait souhaitée', hintText: 'Ex: 19h30'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && timeController.text.isNotEmpty) {
                  cart.temporaryReferenceName = nameController.text;
                  cart.temporaryPickupTime = timeController.text;
                  Navigator.of(dialogContext).pop({
                    'name': nameController.text,
                    'time': timeController.text,
                  });
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );

    if (orderDetails == null) return; 
    final referenceName = orderDetails['name']!;
    final pickupTime = orderDetails['time']!;

    try {
      await orderService.createOrderFromCart(cart, user.id, referenceName, pickupTime);
      cart.clearCart();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Commande pour $referenceName à $pickupTime enregistrée !'), backgroundColor: Colors.green));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la commande: $e'), backgroundColor: Colors.red));
      }
    }
  }

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
                  leading: const Icon(Icons.local_pizza_outlined, color: Colors.orange),
                  title: Text(item.product.name),
                  subtitle: item.selectedIngredients.isNotEmpty
                      ? Text(item.selectedIngredients.map((i) => i.name).join(', '))
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(item.finalPrice * item.quantity).toStringAsFixed(2)} €'),
                      // ✅ NOUVEAU: Ajout de la corbeille
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Supprimer complètement',
                        onPressed: () => cartService.removeItem(itemId),
                      ),
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
                      onPressed: () => _checkout(context),
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
