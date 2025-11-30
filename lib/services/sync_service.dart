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

    // La ligne qui affichait les données brutes a été supprimée.
    // debugPrint("[SyncService] Données brutes reçues de Supabase:");
    // debugPrint(response.toString());

    final List<local_db.ProductsCompanion> products = [];
    for (final json in response) {
      try {
        products.add(local_db.ProductsCompanion.insert(
          name: json['name'] as String,
          basePrice: (json['price'] as num).toDouble(),
          image: Value(json['image_url'] as String?),
          category: const Value(null),
        ));
      } catch (e) {
        // En cas d'erreur de parsing, on reste discret en production.
        debugPrint("[SyncService] Erreur de parsing sur une ligne: $e");
      }
    }

    debugPrint("[SyncService] ${products.length} produits reçus de Supabase.");

    if (products.isEmpty) {
      debugPrint("[SyncService] Aucun nouveau produit à synchroniser.");
      return;
    }

    // Remplacer les anciennes données par les nouvelles
    await db.delete(db.products).go();
    await db.batch((batch) {
      batch.insertAll(db.products, products);
    });

    debugPrint("[SyncService] Synchronisation terminée avec succès.");
  }
}
