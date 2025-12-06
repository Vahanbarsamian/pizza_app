import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/review_service.dart';
import '../services/sync_service.dart';
import 'add_review_screen.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final authService = context.watch<AuthService>();
    final userId = authService.currentUser?.id;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Veuillez vous connecter pour voir vos avis.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Avis'),
      ),
      body: StreamBuilder<List<ReviewWithOrder>>(
        stream: db.watchUserReviews(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Vous n\'avez laissé aucun avis pour le moment.'));
          }

          final reviewsWithOrders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: reviewsWithOrders.length,
            itemBuilder: (context, index) {
              final item = reviewsWithOrders[index];
              return ReviewCard(reviewWithOrder: item);
            },
          );
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewWithOrder reviewWithOrder;

  const ReviewCard({super.key, required this.reviewWithOrder});

  Future<void> _deleteReview(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet avis ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final reviewService = context.read<ReviewService>();
        await reviewService.deleteReview(reviewWithOrder.review.id);
        await context.read<SyncService>().syncAll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avis supprimé.'), backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final review = reviewWithOrder.review;
    final order = reviewWithOrder.order;
    final authService = context.watch<AuthService>();

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
                  TextSpan(text: ', déposé le ${DateFormat('dd/MM/yyyy').format(review.createdAt)}, suite à la commande du ${DateFormat('dd/MM/yyyy').format(order.createdAt)}.'),
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
            const SizedBox(height: 12),
            // ✅ CORRIGÉ: Affiche les boutons uniquement si l'utilisateur est l'auteur de l'avis
            if (authService.currentUser?.id == review.userId)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Modifier'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AddReviewScreen(order: order, existingReview: review),
                      ));
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Supprimer'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => _deleteReview(context),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
