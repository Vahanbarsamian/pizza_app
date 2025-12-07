import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/cart_service.dart';

class PizzaDetailScreen extends StatefulWidget {
  final Product product;
  final bool ordersEnabled;

  const PizzaDetailScreen({super.key, required this.product, required this.ordersEnabled});

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
            // ... Price display ...
            const SizedBox(height: 12),
            if (widget.product.description != null && widget.product.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(widget.product.description!, style: Theme.of(context).textTheme.bodyMedium),
              ),
            const SizedBox(height: 24),
            Text('Suppléments (max $maxSupplements)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            // ... Supplements list ...
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ... Total price display ...
              Flexible(
                flex: 3,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart_checkout),
                  // ✅ CORRIGÉ: Logique de désactivation du bouton
                  label: Text(widget.ordersEnabled ? 'Ajouter au Panier' : 'Commandes fermées'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.ordersEnabled ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: widget.ordersEnabled
                      ? () {
                          cartService.addToCart(widget.product, ingredients: _selectedSupplements);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pizza ajoutée au panier !'), duration: Duration(seconds: 2)),
                          );
                        }
                      : null, // Le bouton est désactivé si onPressed est null
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
