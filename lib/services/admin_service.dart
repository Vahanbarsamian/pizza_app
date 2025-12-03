import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';

class AdminService {
  final AppDatabase db;
  final SupabaseClient _supabase = Supabase.instance.client;

  AdminService({required this.db});

  Future<Map<String, dynamic>> saveProduct({
    int? id,
    required String name,
    required double price,
    String? description,
    String? image,
    int? maxSupplements,
    double? discountPercentage,
  }) async {
    final response = await _supabase.from('products').upsert({
      'id': id,
      'name': name,
      'base_price': price,
      'description': description,
      'image': image,
      'max_supplements': maxSupplements,
      'discount_percentage': discountPercentage,
    }).select();
    return response.first;
  }

  Future<void> deletePizza(int id) async {
    await _supabase.from('products').delete().eq('id', id);
  }

  Future<void> saveIngredient({
    int? id,
    required String name,
    required double price,
    String? category,
    bool isGlobal = false, // ✅ NOUVEAU
  }) async {
    final data = {
      'name': name,
      'price': price,
      'category': category,
      'is_global': isGlobal, // ✅ NOUVEAU
    };
    if (id == null) {
      await _supabase.from('ingredients').insert(data);
    } else {
      await _supabase.from('ingredients').update(data).eq('id', id);
    }
  }

  Future<void> deleteIngredient(int id) async {
    await _supabase.from('ingredients').delete().eq('id', id);
  }

  Future<void> updateProductIngredientLinks(int productId, List<int> ingredientIds) async {
    await _supabase.from('product_ingredient_links').delete().eq('product_id', productId);
    if (ingredientIds.isNotEmpty) {
      final links = ingredientIds.map((id) => {'product_id': productId, 'ingredient_id': id}).toList();
      await _supabase.from('product_ingredient_links').insert(links);
    }
  }

  Future<void> addAnnouncement({
    required String title,
    String? announcementText,
    String? description,
    String? imageUrl,
    String? conclusion,
  }) async {
    await _supabase.from('announcements').insert({
      'title': title,
      'announcement_text': announcementText,
      'description': description,
      'image_url': imageUrl,
      'conclusion': conclusion,
    });
  }

  Future<void> updateAnnouncement(int id, {
    required String title,
    String? announcementText,
    String? description,
    String? imageUrl,
    String? conclusion,
  }) async {
    await _supabase.from('announcements').update({
      'title': title,
      'announcement_text': announcementText,
      'description': description,
      'image_url': imageUrl,
      'conclusion': conclusion,
    }).eq('id', id);
  }

  Future<void> deleteAnnouncement(int id) async {
    await _supabase.from('announcements').delete().eq('id', id);
  }

  Future<void> updateCompanyInfo({
    String? name,
    String? presentation,
    String? address,
    String? phone,
    String? email,
    String? facebookUrl,
    String? instagramUrl,
    String? xUrl,
    String? whatsappPhone,
    double? latitude,
    double? longitude,
  }) async {
    await _supabase.from('company_info').update({
      'name': name,
      'presentation': presentation,
      'address': address,
      'phone': phone,
      'email': email,
      'facebook_url': facebookUrl,
      'instagram_url': instagramUrl,
      'x_url': xUrl,
      'whatsapp_phone': whatsappPhone,
      'latitude': latitude,
      'longitude': longitude,
    }).eq('id', 1);
  }
}
