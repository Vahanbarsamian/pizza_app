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
            final pizzaCount = userLoyalty?.pizzaCount ?? 0;
            final threshold = settings.threshold;

            final pizzasRemaining = threshold - pizzaCount;

            if (pizzasRemaining <= 0) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.green.shade600,
                child: const ListTile(
                  leading: Icon(Icons.star, color: Colors.white, size: 32),
                  title: Text('Félicitations !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('Vous avez une récompense disponible !', style: TextStyle(color: Colors.white70)),
                ),
              );
            }

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
                              sections: _buildPizzaSlices(pizzaCount, threshold),
                              startDegreeOffset: -90,
                              centerSpaceRadius: 25,
                              sectionsSpace: 2,
                            ),
                          ),
                          Center(
                            child: Text(
                              '$pizzaCount/$threshold',
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
                            'Plus que $pizzasRemaining pizzas avant votre prochaine récompense.',
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
        title: '', // Pas de titre sur les parts
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
