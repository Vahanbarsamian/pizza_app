import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart' as local_db;

class SyncService {
  final local_db.AppDatabase db;
  final SupabaseClient supabase = Supabase.instance.client;

  SyncService({required this.db});

  Future<void> syncAll() async {
    await _syncTable('products', db.products, (data) async {
      await db.batch((batch) {
        batch.insertAll(db.products, data.map((row) => local_db.ProductsCompanion(
          id: Value(row['id'] as int),
          name: Value(row['name'] as String),
          description: Value(row['description'] as String?),
          basePrice: Value((row['base_price'] as num).toDouble()),
          image: Value(row['image'] as String?),
          category: Value(row['category'] as String),
          discountPercentage: Value((row['discount_percentage'] as num?)?.toDouble() ?? 0.0),
          hasGlobalDiscount: Value(row['has_global_discount'] as bool? ?? false),
          createdAt: Value(DateTime.parse(row['created_at'])),
          maxSupplements: Value(row['max_supplements'] as int?),
        )));
      });
    });
    await _syncTable('ingredients', db.ingredients, (data) async {
      await db.batch((batch) {
         batch.insertAll(db.ingredients, data.map((row) => local_db.IngredientsCompanion(
            id: Value(row['id'] as int),
            name: Value(row['name'] as String),
            price: Value((row['price'] as num).toDouble()),
            category: Value(row['category'] as String?),
            createdAt: Value(DateTime.parse(row['created_at'])),
         )));
      });
    });
    await _syncTable('product_ingredient_links', db.productIngredientLinks, (data) async {
       await db.batch((batch) {
          batch.insertAll(db.productIngredientLinks, data.map((row) => local_db.ProductIngredientLinksCompanion(
            productId: Value(row['product_id'] as int),
            ingredientId: Value(row['ingredient_id'] as int),
          )));
       });
    });
    await _syncTable('announcements', db.announcements, (data) async {
        await db.batch((batch) {
          batch.insertAll(db.announcements, data.map((row) => local_db.AnnouncementsCompanion(
              id: Value(row['id'] as int),
              title: Value(row['title'] as String),
              announcementText: Value(row['announcement_text'] as String?),
              description: Value(row['description'] as String?),
              imageUrl: Value(row['image_url'] as String?),
              conclusion: Value(row['conclusion'] as String?),
              isActive: Value(row['is_active'] as bool? ?? true),
              createdAt: Value(DateTime.parse(row['created_at'])),
          )));
        });
    });
    await _syncTable('company_info', db.companyInfo, (data) async {
        await db.batch((batch) {
           batch.insertAll(db.companyInfo, data.map((row) => local_db.CompanyInfoCompanion(
              id: Value(row['id'] as int),
              name: Value(row['name'] as String?),
              presentation: Value(row['presentation'] as String?),
              address: Value(row['address'] as String?),
              phone: Value(row['phone'] as String?),
              email: Value(row['email'] as String?),
              facebookUrl: Value(row['facebook_url'] as String?),
              instagramUrl: Value(row['instagram_url'] as String?),
              xUrl: Value(row['x_url'] as String?),
              whatsappPhone: Value(row['whatsapp_phone'] as String?),
              latitude: Value((row['latitude'] as num?)?.toDouble()),
              longitude: Value((row['longitude'] as num?)?.toDouble()),
           )));
        });
    });
    await _syncTable('reviews', db.reviews, (data) async {
      await db.batch((batch) {
        batch.insertAll(db.reviews, data.map((row) => local_db.ReviewsCompanion(
            id: Value(row['id'] as int),
            productId: Value(row['product_id'] as int),
            userId: Value(row['user_id'] as String),
            rating: Value(row['rating'] as int),
            comment: Value(row['comment'] as String?),
            createdAt: Value(DateTime.parse(row['created_at'])),
        )));
      });
    });
    await _syncTable('users', db.users, (data) async {
      await db.batch((batch) {
        batch.insertAll(db.users, data.map((row) => local_db.UsersCompanion(
            id: Value(row['id'] as String),
            name: Value(row['name'] as String?),
            email: Value(row['email'] as String),
            postalCode: Value(row['postal_code'] as String?),
            createdAt: Value(DateTime.parse(row['created_at'])),
        )));
      });
    });
    await _syncTable('admins', db.admins, (data) async {
      await db.batch((batch) {
        batch.insertAll(db.admins, data.map((row) => local_db.AdminsCompanion(
            id: Value(row['id'] as String),
            email: Value(row['email'] as String),
            role: Value(row['role'] as String),
            createdAt: Value(DateTime.parse(row['created_at'])),
        )));
      });
    });
  }

  Future<void> _syncTable(String tableName, TableInfo table, Future<void> Function(List<Map<String, dynamic>>) inserter) async {
    if (kDebugMode) {
      debugPrint("[SyncService] 🔄 Sync $tableName...");
    }
    try {
      final response = await supabase.from(tableName).select();
      final data = (response as List).cast<Map<String, dynamic>>();
      await db.transaction(() async {
        await db.delete(table).go();
        if (data.isNotEmpty) {
          await inserter(data);
        }
      });
      if (kDebugMode) {
        debugPrint("[SyncService] ✅ ${data.length} $tableName synchronisés.");
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[SyncService] ❌ Erreur sync $tableName: $e");
      }
      rethrow;
    }
  }
}
