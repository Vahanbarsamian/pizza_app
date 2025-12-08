import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';

class LoyaltyService {
  final AppDatabase _db;
  final SupabaseClient _supabase = Supabase.instance.client;

  LoyaltyService({required AppDatabase db}) : _db = db;

  Stream<LoyaltySetting?> watchLoyaltySettings() {
    return _db.watchLoyaltySettings();
  }

  Stream<UserLoyalty?> watchUserLoyalty(String userId) {
    return _db.watchUserLoyalty(userId);
  }

  // ✅ AJOUTÉ: Méthode pour mettre à jour le compteur de pizzas
  Future<void> addPizzasToCount(String userId, int newPizzas) async {
    if (newPizzas <= 0) return;

    try {
      // Récupérer le compteur actuel de l'utilisateur
      final response = await _supabase
          .from('user_loyalty')
          .select('pizza_count')
          .eq('user_id', userId)
          .maybeSingle();

      final currentPizzas = (response?['pizza_count'] as int?) ?? 0;
      final totalPizzas = currentPizzas + newPizzas;

      // Mettre à jour le compteur (insert ou update)
      await _supabase.from('user_loyalty').upsert({
        'user_id': userId,
        'pizza_count': totalPizzas,
      });

    } catch (e) {
      print('❌ Erreur lors de la mise à jour du compteur de fidélité: $e');
      // On ne relance pas l'erreur pour ne pas bloquer le processus de commande
    }
  }
}
