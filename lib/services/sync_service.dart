import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart' as local_db;

class SyncService {
  final local_db.AppDatabase db;
  final SupabaseClient supabase = Supabase.instance.client;

  SyncService({required this.db});

  Future<void> syncAll() async {
    await Future.wait([
      syncProducts(),
      syncUsers(),
      syncOrders(),
      syncReviews(),
      syncProductOptions(),
      syncAdmins(),
    ]);
  }

  Future<void> _syncTable(String tableName, TableInfo table, Function(Map<String, dynamic>) fromJson) async {
    if (kDebugMode) {
      debugPrint("[SyncService] 🔄 Sync $tableName...");
    }
    try {
      final response = await supabase.from(tableName).select();

      // ✅ LOG DE DÉBOGAGE: Affiche les données brutes reçues de Supabase
      if (kDebugMode && (tableName == 'admins' || tableName == 'products')) {
        debugPrint("--- [SyncService] Données brutes pour '$tableName' ---");
        debugPrint(response.toString());
        debugPrint("---------------------------------------------------");
      }

      final companions = response.map((json) => fromJson(json)).toList();

      await db.transaction(() async {
        await db.delete(table).go();
        if (companions.isNotEmpty) {
          await db.batch((batch) {
            batch.insertAll(table, companions.cast<Insertable>());
          });
        }
      });

      if (kDebugMode) {
        debugPrint("[SyncService] ✅ ${companions.length} $tableName synchronisés (Miroir)");
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[SyncService] ❌ Erreur sync $tableName: $e");
      }
       rethrow;
    }
  }

  Future<void> syncProducts() => _syncTable('products', db.products, (json) {
        return local_db.ProductsCompanion(
          id: Value(json['id'] as int),
          name: Value(json['name'] as String),
          description: Value(json['description'] as String?),
          basePrice: Value((json['base_price'] ?? 0 as num).toDouble()),
          image: Value(json['image'] as String?),
          category: Value(json['category'] as String? ?? 'pizza'),
          discountPercentage:
              Value((json['discount_percentage'] as num?)?.toDouble() ?? 0.0),
          hasGlobalDiscount: Value(json['has_global_discount'] as bool? ?? false),
          createdAt: Value(
              DateTime.tryParse(json['created_at']?.toString() ?? '') ??
                  DateTime.now()),
        );
      });

  Future<void> syncUsers() => _syncTable('users', db.users, (json) {
        return local_db.UsersCompanion(
          id: Value(json['id'] as String),
          name: Value(json['name'] as String? ?? 'Utilisateur'),
          email: Value(json['email'] as String),
          postalCode: Value(json['postal_code'] as String?),
          createdAt: Value(
              DateTime.tryParse(json['created_at']?.toString() ?? '') ??
                  DateTime.now()),
        );
      });

  Future<void> syncOrders() => _syncTable('orders', db.orders, (json) {
    return local_db.OrdersCompanion(
      id: Value(json['id'] as int),
      userId: Value(json['user_id'] as String),
      total: Value((json['total'] ?? 0 as num).toDouble()),
      status: Value(json['status'] as String? ?? 'pending'),
      createdAt: Value(
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
              DateTime.now()),
    );
  });

  Future<void> syncReviews() => _syncTable('reviews', db.reviews, (json) {
    return local_db.ReviewsCompanion(
      id: Value(json['id'] as int),
      productId: Value((json['product_id'] ?? 0) as int),
      userId: Value(json['user_id'] as String),
      rating: Value((json['rating'] ?? 0) as int),
      comment: Value(json['comment'] as String?),
      createdAt: Value(
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
              DateTime.now()),
    );
  });

  Future<void> syncProductOptions() => _syncTable('options', db.productOptions, (json) {
    return local_db.ProductOptionsCompanion(
      id: Value(json['id'] as int),
      productId: Value((json['product_id'] ?? 0) as int),
      name: Value(json['name'] as String? ?? ''),
      price: Value((json['price'] ?? 0 as num).toDouble()),
    );
  });

  Future<void> syncAdmins() => _syncTable('admins', db.admins, (json) {
    return local_db.AdminsCompanion(
      id: Value(json['id'] as String),
      email: Value(json['email'] as String),
      role: Value(json['role'] as String? ?? 'admin'),
      createdAt: Value(
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
              DateTime.now()),
    );
  });

}
