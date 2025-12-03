import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/review_service.dart';
import '../services/sync_service.dart';

class AddReviewScreen extends StatefulWidget {
  final Order order;
  final Review? existingReview; // Pour la modification

  const AddReviewScreen({super.key, required this.order, this.existingReview});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _rating = widget.existingReview!.rating;
      _commentController.text = widget.existingReview!.comment ?? '';
    }
  }

  Future<void> _submitReview() async {
    final user = context.read<AuthService>().currentUser;
    if (user == null || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une note avant de soumettre.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reviewService = context.read<ReviewService>();
      await reviewService.saveReview(
        reviewId: widget.existingReview?.id,
        orderId: widget.order.id,
        userId: user.id,
        rating: _rating,
        comment: _commentController.text,
      );

      // Rafraîchir les données locales
      await context.read<SyncService>().syncAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Merci pour votre avis !'), backgroundColor: Colors.green),
        );
        // Revenir deux fois pour quitter l'écran de détail de la commande et revenir à l'historique
        Navigator.of(context).pop();
        Navigator.of(context).pop(); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi de l\'avis: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReview == null ? 'Laisser un avis' : 'Modifier mon avis'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quelle note donneriez-vous à cette commande ?', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          ),
                          onPressed: () => setState(() => _rating = index + 1),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Votre commentaire (optionnel)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitReview,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Envoyer mon avis'),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
