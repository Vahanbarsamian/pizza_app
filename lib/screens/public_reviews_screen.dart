import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../services/public_review_service.dart';

class PublicReviewsScreen extends StatelessWidget {
  const PublicReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewService = context.watch<PublicReviewService>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatsHeader(context, reviewService),
            _buildFilterChips(context, reviewService),
            const Divider(),
            Expanded(
              child: reviewService.reviews.isEmpty
                  ? const Center(child: Text('Aucun avis pour cette période.'))
                  : ListView.builder(
                      itemCount: reviewService.reviews.length,
                      itemBuilder: (context, index) {
                        final item = reviewService.reviews[index];
                        return PublicReviewCard(reviewWithOrder: item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, PublicReviewService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(service.totalReviews.toString(), style: Theme.of(context).textTheme.headlineMedium),
              Text('Avis au total', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(service.averageRating.toStringAsFixed(1), style: Theme.of(context).textTheme.headlineMedium),
                  const Icon(Icons.star, color: Colors.amber, size: 30),
                ],
              ),
              Text('Note moyenne', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, PublicReviewService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        alignment: WrapAlignment.center,
        children: [
          ChoiceChip(
            label: const Text('Tout'),
            selected: service.activeFilter == ReviewFilter.all,
            onSelected: (_) => service.setFilter(ReviewFilter.all),
          ),
          ChoiceChip(
            label: const Text('Semaine'),
            selected: service.activeFilter == ReviewFilter.week,
            onSelected: (_) => service.setFilter(ReviewFilter.week),
          ),
          ChoiceChip(
            label: const Text('Mois'),
            selected: service.activeFilter == ReviewFilter.month,
            onSelected: (_) => service.setFilter(ReviewFilter.month),
          ),
          ChoiceChip(
            label: const Text('Année'),
            selected: service.activeFilter == ReviewFilter.year,
            onSelected: (_) => service.setFilter(ReviewFilter.year),
          ),
        ],
      ),
    );
  }
}

class PublicReviewCard extends StatelessWidget {
  final ReviewWithOrder reviewWithOrder;

  const PublicReviewCard({super.key, required this.reviewWithOrder});

  @override
  Widget build(BuildContext context) {
    final review = reviewWithOrder.review;
    final order = reviewWithOrder.order;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                children: [
                  const TextSpan(text: 'Avis de '),
                  TextSpan(text: order.referenceName ?? 'Anonyme', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ', déposé le ${DateFormat('dd/MM/yyyy').format(review.createdAt)}.'),
                ],
              ),
            ),
            const Divider(height: 20),
            if (review.comment != null && review.comment!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  review.comment!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 22,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
