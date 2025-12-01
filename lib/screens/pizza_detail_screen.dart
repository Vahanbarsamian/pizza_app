import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart' hide User;
import '../services/auth_service.dart';
import '../services/cart_service.dart';

class PizzaDetailScreen extends StatelessWidget {
  final Product product;

  const PizzaDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final authService = Provider.of<AuthService>(context);
    final cartService = Provider.of<CartService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (product.image != null)
              Center(
                child: Image.network(
                  product.image!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 24),
            Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('${product.basePrice.toStringAsFixed(2)} € TTC', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.orange)),
            const SizedBox(height: 16),
            if (product.description != null && product.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(product.description!, style: Theme.of(context).textTheme.bodyLarge),
              ),

            const Text('Options et suppléments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<List<ProductOption>>(
              stream: db.watchProductOptions(product.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(padding: EdgeInsets.all(8.0), child: Text('Aucune option disponible.'));
                }
                final options = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    // ✅ CORRIGÉ: Augmentation de la taille de la police pour les options
                    return ListTile(
                      title: Text(option.name, style: const TextStyle(fontSize: 16)),
                      trailing: Text('+ ${option.price.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    );
                  },
                );
              },
            ),
            const Divider(height: 40),

            const Text('Avis des clients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<List<Review>>(
              stream: db.watchProductReviews(product.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(padding: EdgeInsets.all(8.0), child: Text('Aucun avis pour le moment.'));
                }
                final reviews = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ListTile(
                      leading: const Icon(Icons.comment),
                      title: Text(review.comment ?? 'Pas de commentaire.'),
                      subtitle: Text('Note: ${review.rating}/5'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              onPressed: () {
                cartService.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${product.name}" ajouté au panier !')),
                );
              },
              label: const Text('Ajouter au panier'),
              icon: const Icon(Icons.add_shopping_cart),
              backgroundColor: Colors.orange,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
