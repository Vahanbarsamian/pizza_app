import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart' as local_db;

class SyncService {
  final local_db.AppDatabase db;
  final SupabaseClient supabase = Supabase.instance.client;

  SyncService({required this.db});

  Future<void> syncProducts() async {
    debugPrint("[SyncService] Démarrage de la synchronisation...");

    final response = await supabase.from('products').select();

    debugPrint("[SyncService] Données brutes reçues de Supabase:");
    debugPrint(response.toString());

    final List<local_db.ProductsCompanion> products = [];
    for (final json in response) {
      try {
        // ✅ CORRECTION FINALE: Utilisation des bons noms de colonnes de Supabase
        products.add(local_db.ProductsCompanion.insert(
          name: json['name'] as String,
          basePrice: (json['price'] as num).toDouble(), // <= Utilise 'price'
          image: Value(json['image_url'] as String?),   // <= Utilise 'image_url'
          // La catégorie n'est pas dans le JSON, donc elle sera null, ce qui est ok.
          category: const Value(null),
        ));
      } catch (e) {
        debugPrint("--- ERREUR DE PARSING ---");
        debugPrint("  Ligne JSON qui a échoué: $json");
        debugPrint("  Erreur spécifique: $e");
        debugPrint("-------------------------");
      }
    }

    debugPrint("[SyncService] ${products.length} produits ont été parsés avec succès.");

    if (products.isEmpty) {
      debugPrint("[SyncService] Aucun produit à insérer. Fin de la synchronisation.");
      return;
    }

    await db.delete(db.products).go();
    await db.batch((batch) {
      batch.insertAll(db.products, products);
    });

    debugPrint("[SyncService] Synchronisation terminée avec succès.");
  }
}
