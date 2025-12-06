import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/cart_service.dart';

class PizzaDetailScreen extends StatefulWidget {
  final Product product;

  const PizzaDetailScreen({super.key, required this.product});

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  List<Ingredient> _selectedSupplements = [];

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final db = Provider.of<AppDatabase>(context);
    final hasImage = widget.product.image != null && widget.product.image!.isNotEmpty;
    final maxSupplements = widget.product.maxSupplements ?? 4;
    final canAddMore = _selectedSupplements.length < maxSupplements;

    final hasDiscount = widget.product.discountPercentage > 0;
    final reducedPrice = widget.product.basePrice * (1 - widget.product.discountPercentage);
    
    final supplementsPrice = _selectedSupplements.fold<double>(0, (sum, item) => sum + item.price);
    final totalPrice = (hasDiscount ? reducedPrice : widget.product.basePrice) + supplementsPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.product.image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              ),
            const SizedBox(height: 16),
            Text(widget.product.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasDiscount)
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 24),
                      children: [
                        TextSpan(text: reducedPrice.toStringAsFixed(2)),
                        const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      decoration: hasDiscount ? TextDecoration.lineThrough : TextDecoration.none,
                      decorationColor: Colors.red, 
                      color: hasDiscount ? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: hasDiscount ? FontWeight.normal : FontWeight.bold,
                      fontSize: hasDiscount ? 20 : 24,
                    ),
                    children: [
                      TextSpan(text: widget.product.basePrice.toStringAsFixed(2)),
                      const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.product.description != null && widget.product.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(widget.product.description!, style: Theme.of(context).textTheme.bodyMedium),
              ),
            const SizedBox(height: 24),
            Text('Suppléments (max $maxSupplements)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            StreamBuilder<List<Ingredient>>(
              stream: db.watchIngredientsForProduct(widget.product.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final ingredients = snapshot.data!;
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: ingredients.map((ingredient) {
                    final isSelected = _selectedSupplements.contains(ingredient);
                    return ChoiceChip(
                      label: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '${ingredient.name} (+'),
                            TextSpan(text: ingredient.price.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: ' € TTC)'),
                          ],
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.orange.shade200,
                      onSelected: (selected) { // ✅ CORRIGÉ
                        setState(() {
                          if (selected && canAddMore) {
                            _selectedSupplements.add(ingredient);
                          } else if (!selected) {
                            _selectedSupplements.remove(ingredient);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
                    children: [
                      TextSpan(text: totalPrice.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 3,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart_checkout),
                  label: const Text('Ajouter au Panier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    cartService.addToCart(widget.product, ingredients: _selectedSupplements);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pizza ajoutée au panier !'), duration: Duration(seconds: 2)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
