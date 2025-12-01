import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';

class AdminService {
  final AppDatabase db;
  final SupabaseClient _supabase = Supabase.instance.client;

  AdminService({required this.db});

  Future<void> addPizza({
    required String name,
    required double price,
    String? description,
    String? image,
    String category = 'pizza',
    double discount = 0.0,
    bool hasGlobalDiscount = false,
  }) async {
    try {
      debugPrint("[AdminService] Tentative d'insertion dans Supabase...");
      await _supabase.from('products').insert({
        'name': name,
        'base_price': price,
        'description': description,
        'image': image,
        'category': category,
        'discount_percentage': discount,
        'has_global_discount': hasGlobalDiscount,
      });
      debugPrint("[AdminService] ✅ Insertion Supabase réussie pour '$name'.");
    } catch (e) {
      // ✅ On rend l'erreur "bruyante"
      debugPrint("--- ERREUR SUPABASE DÉTECTÉE DANS AdminService ---");
      debugPrint("L'insertion de la pizza '$name' a échoué.");
      debugPrint("Erreur: ${e.toString()}");
      debugPrint("---------------------------------------------------");
      // On relance l'erreur pour que l'UI puisse la gérer
      rethrow;
    }
  }

  Future<int> getPizzaCount() async {
    return await db.countProducts();
  }
}
