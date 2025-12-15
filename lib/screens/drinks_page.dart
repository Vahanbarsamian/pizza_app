import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../widgets/product_display_card.dart'; // ✅ CORRIGÉ

class DrinksPage extends StatelessWidget {
  const DrinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final authService = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Boissons'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: db.watchAllDrinks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final drinks = snapshot.data ?? [];
          if (drinks.isEmpty) {
            return const Center(child: Text('Aucune boisson disponible pour le moment.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75, 
            ),
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              final drink = drinks[index];
              // ✅ CORRIGÉ: Utilisation du widget partagé
              return ProductDisplayCard(product: drink, isAdmin: authService.isAdmin, ordersEnabled: true);
            },
          );
        },
      ),
    );
  }
}
