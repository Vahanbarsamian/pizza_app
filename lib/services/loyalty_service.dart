import 'dart:async';
import 'package:drift/drift.dart';
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

  Future<void> addPoints(String userId, int pointsToAdd) async {
    if (pointsToAdd == 0) return;

    try {
      final response = await _supabase
          .from('user_loyalty')
          .select('points')
          .eq('user_id', userId)
          .maybeSingle();

      final currentPoints = (response?['points'] as int?) ?? 0;
      final totalPoints = currentPoints + pointsToAdd;
      final newPoints = totalPoints < 0 ? 0 : totalPoints;

      await _supabase.from('user_loyalty').upsert({
        'user_id': userId,
        'points': newPoints,
      });

      // ✅ CORRIGÉ: Encapsule la valeur dans Value()
      await _db.into(_db.userLoyalties).insert(
        UserLoyaltiesCompanion.insert(
          userId: userId,
          pizzaCount: Value(newPoints),
        ),
        mode: InsertMode.replace,
      );

    } catch (e) {
      print('❌ Erreur lors de la mise à jour des points de fidélité: $e');
    }
  }
}
