import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';

class AdminService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;

  AdminService({required AppDatabase db}) : _db = db;

  Future<Map<String, dynamic>> saveProduct({
    int? id,
    required String name,
    required double price,
    String? description,
    double? discountPercentage,
    int? maxSupplements,
  }) async {
    final data = {
      'name': name,
      'base_price': price,
      'description': description,
      'discount_percentage': discountPercentage,
      'max_supplements': maxSupplements,
    };

    if (id != null) {
      return (await _supabase.from('products').update(data).eq('id', id).select()).first;
    } else {
      return (await _supabase.from('products').insert(data).select()).first;
    }
  }

  Future<void> updateProductIngredientLinks(int productId, List<int> ingredientIds) async {
    await _supabase.from('product_ingredient_links').delete().eq('product_id', productId);
    if (ingredientIds.isNotEmpty) {
      final links = ingredientIds.map((id) => {'product_id': productId, 'ingredient_id': id}).toList();
      await _supabase.from('product_ingredient_links').insert(links);
    }
  }

  Future<void> saveIngredient(IngredientsCompanion ingredient) async {
    await _db.into(_db.ingredients).insert(ingredient, mode: InsertMode.replace);
    final response = await _supabase.from('ingredients').upsert({
      'id': ingredient.id.value,
      'name': ingredient.name.value,
      'price': ingredient.price.value,
      'category': ingredient.category.value,
      'is_global': ingredient.isGlobal.value,
      'created_at': (ingredient.createdAt.value ?? DateTime.now()).toIso8601String(),
    });
  }

  Future<void> deleteIngredient(int id) async {
    await _supabase.from('ingredients').delete().eq('id', id);
    await (_db.delete(_db.ingredients)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> saveCompanyInfo(CompanyInfoCompanion info) async {
    final data = {
      'id': info.id.value,
      'name': info.name.value,
      'presentation': info.presentation.value,
      'address': info.address.value,
      'phone': info.phone.value,
      'email': info.email.value,
      'facebook_url': info.facebookUrl.value,
      'instagram_url': info.instagramUrl.value,
      'x_url': info.xUrl.value,
      'whatsapp_phone': info.whatsappPhone.value,
      'latitude': info.latitude.value,
      'longitude': info.longitude.value,
    };
    await _supabase.from('company_info').upsert(data);
  }

  Future<void> saveAnnouncement({
    int? id,
    required String title,
    String? announcementText,
    String? description,
    String? imageUrl,
    String? conclusion,
    required bool isActive,
    required String type,
  }) async {
    final data = {
      'title': title,
      'announcement_text': announcementText,
      'description': description,
      'image_url': imageUrl,
      'conclusion': conclusion,
      'is_active': isActive,
      'type': type,
    };

    if (id != null) {
      await _supabase.from('announcements').update(data).eq('id', id);
    } else {
      await _supabase.from('announcements').insert(data);
    }
  }

  Future<void> deleteAnnouncement(int id) async {
    await _supabase.from('announcements').delete().eq('id', id);
  }

  // ✅ CORRIGÉ: Met à jour le statut en créant une nouvelle entrée dans l'historique
  Future<void> updateOrderStatus(int orderId, String status) async {
    final now = DateTime.now();
    await _supabase.from('order_status_histories').insert({
      'order_id': orderId,
      'status': status,
      'created_at': now.toIso8601String(),
    });
    // Met également à jour le champ `updated_at` de la commande principale pour le tri
    await _supabase.from('orders').update({'updated_at': now.toIso8601String()}).eq('id', orderId);
  }
}
