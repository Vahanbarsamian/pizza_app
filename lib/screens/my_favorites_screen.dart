import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../widgets/product_display_card.dart';

class MyFavoritesScreen extends StatelessWidget {
  const MyFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final authService = context.watch<AuthService>();
    final userId = authService.currentUser?.id;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mes Favoris')),
        body: const Center(child: Text('Veuillez vous connecter pour voir vos favoris.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Product>>(
        stream: db.watchUserFavorites(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Vous n\'avez pas encore de favoris.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('Cliquez sur le ❤️ des pizzas pour les ajouter ici.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              // On passe ordersEnabled: true par défaut, le ProductDisplayCard gérera l'affichage
              return ProductDisplayCard(product: product, isAdmin: false, ordersEnabled: true);
            },
          );
        },
      ),
    );
  }
}
