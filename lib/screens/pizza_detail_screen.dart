import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../models/cart_item.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import 'login_screen.dart';

class PizzaDetailScreen extends StatefulWidget {
  final Product product;

  const PizzaDetailScreen({super.key, required this.product});

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> with SingleTickerProviderStateMixin {
  final List<Ingredient> _selectedIngredients = [];
  late CartItem _cartItem;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _cartItem = CartItem(product: widget.product);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onIngredientSelected(bool? selected, Ingredient ingredient) {
    setState(() {
      if (selected == true) {
        _selectedIngredients.add(ingredient);
      } else {
        _selectedIngredients.remove(ingredient);
      }
      _cartItem = CartItem(product: widget.product, selectedIngredients: _selectedIngredients);
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final authService = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Column(
        children: [
          if (widget.product.image != null && widget.product.image!.isNotEmpty)
            Image.network(widget.product.image!, height: 250, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.product.name, style: Theme.of(context).textTheme.headlineMedium),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Suppléments'),
              Tab(text: 'Avis des clients'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIngredientsTab(db),
                _buildReviewsTab(db),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(text: '${_cartItem.finalPrice.toStringAsFixed(2)} '),
                        const TextSpan(text: '€ TTC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: authService.currentUser != null
                    ? ElevatedButton.icon(
                        onPressed: () {
                           Provider.of<CartService>(context, listen: false).addToCart(widget.product, ingredients: _selectedIngredients);
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pizza ajoutée au panier !')));
                           Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Ajouter au panier'),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                        icon: const Icon(Icons.login),
                        label: const Text('Se connecter pour commander'),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsTab(AppDatabase db) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.description ?? '', style: Theme.of(context).textTheme.bodyLarge),
          const Divider(height: 32),
          Text('Ingrédients supplémentaires', style: Theme.of(context).textTheme.titleLarge),
          StreamBuilder<List<Ingredient>>(
            stream: db.watchIngredientsForProduct(widget.product.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Aucun supplément disponible pour cette pizza.'),
                );
              }
              final ingredients = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];
                  return CheckboxListTile(
                    title: Text(ingredient.name),
                    subtitle: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: <TextSpan>[
                          TextSpan(text: '+ ${ingredient.price.toStringAsFixed(2)} '),
                          const TextSpan(text: '€ TTC', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    value: _selectedIngredients.contains(ingredient),
                    onChanged: (selected) => _onIngredientSelected(selected, ingredient),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(AppDatabase db) {
    return StreamBuilder<List<Review>>(
      stream: db.watchProductReviews(widget.product.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun avis pour cette pizza pour le moment.'));
        }
        final reviews = snapshot.data!;
        return ListView.separated(
          itemCount: reviews.length,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ListTile(
              title: Row(
                children: List.generate(5, (starIndex) {
                  return Icon(
                    starIndex < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  );
                }),
              ),
              subtitle: Text(review.comment ?? 'Pas de commentaire.'),
            );
          },
        );
      },
    );
  }
}
