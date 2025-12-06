import 'dart:async';

import '../database/app_database.dart';

class LoyaltyService {
  final AppDatabase _db;

  LoyaltyService({required AppDatabase db}) : _db = db;

  // Fournit un flux continu des réglages de fidélité
  Stream<LoyaltySetting?> watchLoyaltySettings() {
    return _db.watchLoyaltySettings();
  }

  // Fournit un flux continu des points de l'utilisateur connecté
  Stream<UserLoyalty?> watchUserLoyalty(String userId) {
    return _db.watchUserLoyalty(userId);
  }
}
