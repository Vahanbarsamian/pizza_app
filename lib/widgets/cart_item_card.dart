import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';

class CartItemCard extends StatelessWidget {
  final String uniqueId;
  final CartItem item;

  const CartItemCard({super.key, required this.uniqueId, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartService>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Suppléments: ${item.selectedIngredients.map((i) => i.name).join(', ')}'),
                  Text('${item.finalPrice.toStringAsFixed(2)} €', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cart.updateQuantity(uniqueId, item.quantity - 1)),
                Text(item.quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cart.updateQuantity(uniqueId, item.quantity + 1)),
              ],
            ),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => cart.removeItem(uniqueId)),
          ],
        ),
      ),
    );
  }
}
