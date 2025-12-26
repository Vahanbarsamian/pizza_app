import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../database/app_database.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart'; // ✅ AJOUT
import 'login_screen.dart'; // ✅ AJOUT

class DrinkDetailScreen extends StatelessWidget {
  final Product product;

  const DrinkDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartService = context.read<CartService>();
    final authService = context.watch<AuthService>(); // ✅ Écoute de l'auth
    final isLoggedIn = authService.currentUser != null; // ✅ Vérification
    final hasImage = product.image != null && product.image!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: product.image!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => _buildPlaceholderIcon(),
                      )
                    : _buildPlaceholderIcon(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${product.basePrice.toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 32),
            if (product.description != null && product.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  product.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            // ✅ MODIFIÉ : Icône et Libellé dynamiques
            icon: Icon(isLoggedIn ? Icons.add_shopping_cart : Icons.login),
            label: Text(isLoggedIn ? 'Ajouter au panier' : 'Connexion'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (isLoggedIn) {
                cartService.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} ajouté au panier !'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 1),
                  ),
                );
                Navigator.of(context).pop();
              } else {
                // ✅ AJOUT : Redirection si non connecté
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.bottleWater,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }
}
