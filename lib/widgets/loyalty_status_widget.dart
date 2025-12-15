import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

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

    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<LoyaltySetting?>( 
      stream: loyaltyService.watchLoyaltySettings(),
      builder: (context, settingsSnapshot) {
        final settings = settingsSnapshot.data;

        if (settings == null || !settings.isEnabled) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<UserLoyalty?>(
          stream: loyaltyService.watchUserLoyalty(currentUser.id),
          builder: (context, loyaltySnapshot) {
            final userLoyalty = loyaltySnapshot.data;
            // ✅ CORRIGÉ: Utilisation de 'pizzaCount' au lieu de 'points'
            final points = userLoyalty?.pizzaCount ?? 0;
            final threshold = settings.threshold;

            // Si l'utilisateur a atteint ou dépassé le seuil
            if (points >= threshold) {
              // ✅ MODIFIÉ: Logique d'affichage améliorée pour la récompense
              final extraPoints = points - threshold;
              String subtitleText = 'Utilisez votre récompense sur la prochaine commande !';
              if (extraPoints > 0) {
                subtitleText += ' Vous avez déjà $extraPoints point(s) pour la suivante.';
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.green.shade600,
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.white, size: 32),
                  title: const Text('Félicitations, récompense disponible !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(subtitleText, style: const TextStyle(color: Colors.white70)),
                ),
              );
            }

            // Affichage normal du compteur de progression
            final pointsRemaining = threshold - points;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sections: _buildPizzaSlices(points, threshold),
                              startDegreeOffset: -90,
                              centerSpaceRadius: 25,
                              sectionsSpace: 2,
                            ),
                          ),
                          Center(
                            child: Text(
                              '$points/$threshold',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Votre fidélité', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            'Plus que $pointsRemaining pizzas avant votre prochaine récompense.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ), 
              ),
            );
          },
        );
      },
    );
  }

  List<PieChartSectionData> _buildPizzaSlices(int count, int threshold) {
    final filledPercentage = (count / threshold) * 100;
    final remainingPercentage = 100 - filledPercentage;

    return [
      PieChartSectionData(
        color: Colors.orange.shade600,
        value: filledPercentage,
        title: '',
        radius: 20,
      ),
      PieChartSectionData(
        color: Colors.grey.shade300,
        value: remainingPercentage,
        title: '',
        radius: 20,
      ),
    ];
  }
}
