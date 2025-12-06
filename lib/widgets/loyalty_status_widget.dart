import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/loyalty_service.dart';

class LoyaltyStatusWidget extends StatelessWidget {
  const LoyaltyStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loyaltyService = context.watch<LoyaltyService>();
    final authService = context.watch<AuthService>();
    final currentUser = authService.currentUser;

    // Si l'utilisateur n'est pas connecté, on n'affiche rien
    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<LoyaltySetting?>(
      stream: loyaltyService.watchLoyaltySettings(),
      builder: (context, settingsSnapshot) {
        final settings = settingsSnapshot.data;

        // Si les réglages n'existent pas ou si le système est désactivé, on n'affiche rien
        if (settings == null || !settings.isEnabled) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<UserLoyalty?>(
          stream: loyaltyService.watchUserLoyalty(currentUser.id),
          builder: (context, loyaltySnapshot) {
            final userLoyalty = loyaltySnapshot.data;
            final pizzaCount = userLoyalty?.pizzaCount ?? 0;
            final threshold = settings.threshold;

            final pizzasRemaining = threshold - pizzaCount;

            // Si l'utilisateur a déjà sa récompense ou plus, on peut afficher un message différent
            if (pizzasRemaining <= 0) {
              return const Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.green,
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.white),
                  title: Text('Félicitations ! Vous avez une récompense !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              );
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.loyalty_outlined),
                title: const Text('Votre fidélité'),
                subtitle: Text('Plus que $pizzasRemaining pizzas avant votre prochaine récompense.'),
                trailing: Text('$pizzaCount / $threshold', style: Theme.of(context).textTheme.titleMedium),
              ),
            );
          },
        );
      },
    );
  }
}
