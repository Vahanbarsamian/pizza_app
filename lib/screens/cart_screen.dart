import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartService>();
    final orderService = context.read<OrderService>();
    final authService = context.read<AuthService>();
    final syncService = context.read<SyncService>();
    final user = authService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter pour commander.'), backgroundColor: Colors.amber),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }

    final orderDetails = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        final nameController = TextEditingController(text: cart.temporaryReferenceName);
        final timeController = TextEditingController(text: cart.temporaryPickupTime);
        String paymentMethod = 'Carte Bleue';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Finaliser la commande'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 24),
                    Text('Mode de paiement:', style: Theme.of(context).textTheme.titleSmall),
                    RadioListTile<String>(
                      title: const Text('Carte Bleue'),
                      value: 'Carte Bleue',
                      groupValue: paymentMethod,
                      onChanged: (value) => setState(() => paymentMethod = value!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Paypal'),
                      value: 'Paypal',
                      groupValue: paymentMethod,
                      onChanged: (value) => setState(() => paymentMethod = value!),
                    ),
                  ],
                ),
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
                        'payment': paymentMethod,
                      });
                    }
                  },
                  child: const Text('Valider'),
                ),
              ],
            );
          },
        );
      },
    );

    if (orderDetails == null) return;
    final referenceName = orderDetails['name']!;
    final pickupTime = orderDetails['time']!;
    final paymentMethod = orderDetails['payment']!;

    try {
      await orderService.createOrderFromCart(cart, user.id, referenceName, pickupTime, paymentMethod);
      await syncService.syncAll();
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
    final authService = context.watch<AuthService>();

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
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(fontSize: 16),
                          children: [
                            TextSpan(text: (item.finalPrice * item.quantity).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
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
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.titleLarge,
                          children: [
                            const TextSpan(text: 'Total: '),
                            TextSpan(text: cartService.totalPrice.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<AuthService>(
                        builder: (context, auth, child) {
                          final buttonStyle = ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          );
                          if (auth.currentUser != null) {
                            return ElevatedButton(
                              onPressed: () => _checkout(context),
                              style: buttonStyle,
                              child: const Text('Payer'),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                              },
                              style: buttonStyle,
                              child: const Text('Connexion'),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
