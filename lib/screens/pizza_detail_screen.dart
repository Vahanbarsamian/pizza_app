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
            if (widget.product.description != null)
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
                      label: Text('${ingredient.name} (+${ingredient.price.toStringAsFixed(2)} €)'),
                      selected: isSelected,
                      selectedColor: Colors.orange.shade200,
                      onSelected: (selected) {
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
            // ✅ SUPPRIMÉ: L'ancienne section des avis a été retirée de cet écran.
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Ajouter au Panier'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }
}
