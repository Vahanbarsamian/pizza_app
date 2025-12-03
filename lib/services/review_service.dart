import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> saveReview({
    int? reviewId,
    required int orderId,
    required String userId,
    required int rating,
    String? comment,
  }) async {
    final Map<String, dynamic> data = {
      'order_id': orderId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
    };

    if (reviewId != null) {
      // Mise à jour d'un avis existant
      await _supabase.from('reviews').update(data).eq('id', reviewId);
    } else {
      // Création d'un nouvel avis
      await _supabase.from('reviews').insert(data);
    }
  }

  Future<void> deleteReview(int reviewId) async {
    await _supabase.from('reviews').delete().eq('id', reviewId);
  }
}
