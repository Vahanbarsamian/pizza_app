import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'login_screen.dart';
import 'checkout_screen.dart';

String formatPrice(double price) {
  return '${price.toStringAsFixed(2)} € TTC';
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;

  Widget? _buildOptionsSubtitle(BuildContext context, CartItem item) {
    final options = <String>[];
    if (item.selectedIngredients.isNotEmpty) {
      options.add(item.selectedIngredients.map((i) => '+ ${i.name}').join(', '));
    }
    if (item.removedIngredients.isNotEmpty) {
      options.add(item.removedIngredients.map((i) => '(sans ${i.name})').join(', '));
    }

    if (options.isEmpty) return null;

    return Text(options.join(', '), style: const TextStyle(color: Colors.grey));
  }

  Future<void> _checkout(BuildContext context) async {
    if (_isCheckingOut) return;
    setState(() => _isCheckingOut = true);

    final cart = context.read<CartService>();
    final orderService = context.read<OrderService>();
    final authService = context.read<AuthService>();
    final syncService = context.read<SyncService>();
    final user = authService.currentUser;

    try {
      if (user == null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
        return;
      }

      final orderDetails = await Navigator.of(context).push<Map<String, String>>(
        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
      );

      if (orderDetails == null) {
          setState(() => _isCheckingOut = false);
          return;
      }

      final referenceName = orderDetails['name']!;
      final pickupTime = orderDetails['time']!;
      final paymentMethod = orderDetails['payment']!;

      // ✅ CORRIGÉ: Appel mis à jour sans le service de fidélité
      await orderService.createOrderFromCart(cart, user.id, referenceName, pickupTime, paymentMethod);
      
      // La synchronisation est cruciale pour que le client voie sa commande et ses points à jour
      await syncService.syncAll(); 
      
      cart.clearCart();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Commande pour $referenceName à $pickupTime enregistrée !'), backgroundColor: Colors.green));
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la commande: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if(mounted) {
        setState(() => _isCheckingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final authService = context.watch<AuthService>();
    final bool isLoggedIn = authService.currentUser != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Votre Panier')),
      body: cartService.items.isEmpty
          ? const Center(child: Text('Votre panier est vide.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: cartService.items.length,
              itemBuilder: (context, index) {
                final itemId = cartService.items.keys.elementAt(index);
                final item = cartService.items[itemId]!;

                return ListTile(
                  leading: const Icon(Icons.local_pizza_outlined, color: Colors.orange),
                  title: Text(item.product.name),
                  subtitle: _buildOptionsSubtitle(context, item),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(formatPrice(item.finalPrice * item.quantity)),
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cartService.updateQuantity(itemId, item.quantity - 1)),
                      Text(item.quantity.toString(), style: const TextStyle(fontSize: 18)),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cartService.updateQuantity(itemId, item.quantity + 1)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), tooltip: 'Supprimer complètement', onPressed: () => cartService.removeItem(itemId)),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cartService.items.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Total: ${formatPrice(cartService.totalPrice)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: _isCheckingOut ? null : () {
                        if (isLoggedIn) {
                          _checkout(context);
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                        }
                      },
                      child: _isCheckingOut
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : Text(isLoggedIn ? 'Payer' : 'Connexion'),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
