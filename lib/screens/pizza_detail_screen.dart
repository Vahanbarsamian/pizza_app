import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

String formatPrice(double price) {
  return '${price.toStringAsFixed(2)} € TTC';
}

class PizzaDetailScreen extends StatefulWidget {
  final Product product;
  final bool ordersEnabled;

  const PizzaDetailScreen({super.key, required this.product, required this.ordersEnabled});

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  List<Ingredient> _removedBaseIngredients = [];
  List<Ingredient> _selectedSupplements = [];

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false);
    final db = Provider.of<AppDatabase>(context, listen: false);
    final authService = context.watch<AuthService>();
    final isLoggedIn = authService.currentUser != null;

    final hasImage = widget.product.image != null && widget.product.image!.isNotEmpty;
    
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
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (hasDiscount)
                  Text(
                    formatPrice(widget.product.basePrice),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  formatPrice(hasDiscount ? reducedPrice : widget.product.basePrice),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: hasDiscount ? Colors.red : Colors.black,
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
            
            StreamBuilder<Map<String, List<Ingredient>>>(
              stream: db.watchIngredientsForProductSeparated(widget.product.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final baseIngredients = snapshot.data!['base'] ?? [];
                final supplements = snapshot.data!['supplements'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (baseIngredients.isNotEmpty)
                      _buildBaseIngredientsSection(baseIngredients),
                    
                    if (supplements.isNotEmpty)
                      _buildSupplementsSection(supplements),
                  ],
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
                child: Text(
                  formatPrice(totalPrice),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 3,
                child: ElevatedButton.icon(
                  icon: Icon(isLoggedIn ? Icons.shopping_cart_checkout : Icons.login),
                  label: Text(isLoggedIn ? (widget.ordersEnabled ? 'Ajouter au Panier' : 'Commandes fermées') : 'Connexion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.ordersEnabled ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (!isLoggedIn) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                    } else if (widget.ordersEnabled) {
                      cartService.addToCart(
                        widget.product,
                        addedSupplements: _selectedSupplements, 
                        removedIngredients: _removedBaseIngredients
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pizza ajoutée au panier !'), duration: Duration(seconds: 2)),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBaseIngredientsSection(List<Ingredient> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text('Composition', style: Theme.of(context).textTheme.titleLarge),
        // ✅ AJOUTÉ: Texte d'aide
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Text(
            'Décochez pour retirer un ingrédient',
            style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
          ),
        ),
        ...ingredients.map<Widget>((ingredient) {
          final isRemoved = _removedBaseIngredients.contains(ingredient);
          return CheckboxListTile(
            title: Text(ingredient.name, style: TextStyle(decoration: isRemoved ? TextDecoration.lineThrough : null)),
            value: !isRemoved,
            onChanged: (selected) {
              setState(() {
                if (selected == false) {
                  _removedBaseIngredients.add(ingredient);
                } else {
                  _removedBaseIngredients.remove(ingredient);
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSupplementsSection(List<Ingredient> ingredients) {
    final maxSupplements = widget.product.maxSupplements ?? 4;
    final canAddMore = _selectedSupplements.length < maxSupplements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text('Suppléments (max $maxSupplements)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: ingredients.map<Widget>((ingredient) {
            final isSelected = _selectedSupplements.contains(ingredient);
            return ChoiceChip(
              label: Text.rich(TextSpan(children: [TextSpan(text: '${ingredient.name} (+'), TextSpan(text: ingredient.price.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)), const TextSpan(text: ' € TTC)')])), 
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
        ),
      ],
    );
  }
}
