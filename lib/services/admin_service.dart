import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../screens/admin_orders_tab.dart';

class AdminService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;

  AdminService({required AppDatabase db}) : _db = db;

  Future<LoyaltySetting?> getLoyaltySettings() async {
    final data = await _supabase.from('loyalty_settings').select().eq('id', 1).maybeSingle();
    if (data == null) return null;
    return LoyaltySetting(
      id: data['id'] ?? 1,
      isEnabled: data['is_enabled'] ?? false,
      mode: data['mode'] ?? 'free_pizza',
      threshold: data['threshold'] ?? 10,
      discountPercentage: (data['discount_percentage'] as double?) ?? 0.1,
    );
  }

  Future<void> saveLoyaltySettings(LoyaltySettingsCompanion settings) async {
    final dataToSave = <String, dynamic>{};
    if (settings.isEnabled.present) dataToSave['is_enabled'] = settings.isEnabled.value;
    if (settings.mode.present) dataToSave['mode'] = settings.mode.value;
    if (settings.threshold.present) dataToSave['threshold'] = settings.threshold.value;
    if (settings.discountPercentage.present) dataToSave['discount_percentage'] = settings.discountPercentage.value;

    await _supabase.from('loyalty_settings').update(dataToSave).eq('id', 1);
  }

  Future<void> archiveTodaysWork() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

    final finishedOrdersResponse = await _supabase
        .from('order_status_histories')
        .select('order_id')
        .eq('status', 'Terminée')
        .gte('created_at', startOfDay)
        .lte('created_at', endOfDay);

    final orderIds = finishedOrdersResponse.map((row) => row['order_id'] as int).toSet().toList();

    if (orderIds.isEmpty) {
      return;
    }

    await _supabase.from('orders').update({'is_archived': true}).filter('id', 'in', orderIds);
  }

  Future<void> saveStoreStatus({
    required bool ordersEnabled,
    ClosureMessageType? messageType,
    DateTime? startDate,
    DateTime? endDate,
    String? customMessage,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final Map<String, dynamic> dataToSave = {
      'orders_enabled': ordersEnabled,
      'closure_message_type': messageType?.name,
      'closure_start_date': startDate != null ? dateFormat.format(startDate) : null,
      'closure_end_date': endDate != null ? dateFormat.format(endDate) : null,
      'closure_custom_message': customMessage,
    };
    await _supabase.from('company_info').update(dataToSave).eq('id', 1);
  }

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
    await _supabase.from('ingredients').upsert({
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
    final data = <String, dynamic>{
      'id': info.id.value,
    };
    if (info.name.present) data['name'] = info.name.value;
    if (info.presentation.present) data['presentation'] = info.presentation.value;
    if (info.address.present) data['address'] = info.address.value;
    if (info.phone.present) data['phone'] = info.phone.value;
    if (info.email.present) data['email'] = info.email.value;
    if (info.facebookUrl.present) data['facebook_url'] = info.facebookUrl.value;
    if (info.instagramUrl.present) data['instagram_url'] = info.instagramUrl.value;
    if (info.xUrl.present) data['x_url'] = info.xUrl.value;
    if (info.whatsappPhone.present) data['whatsapp_phone'] = info.whatsappPhone.value;
    if (info.latitude.present) data['latitude'] = info.latitude.value;
    if (info.longitude.present) data['longitude'] = info.longitude.value;
    if (info.logoUrl.present) data['logo_url'] = info.logoUrl.value;
    if (info.tvaRate.present) data['tva_rate'] = info.tvaRate.value;

    print('ℹ️ [AdminService] Début de la sauvegarde CompanyInfo.');
    print('ℹ️ [AdminService] Données envoyées: $data');
    try {
      await _supabase.from('company_info').upsert(data);
      print('✅ [AdminService] CompanyInfo sauvegardé avec succès.');
    } catch (e) {
      print('❌ [AdminService] Erreur lors de la sauvegarde de CompanyInfo: $e');
      rethrow; // Important pour que l'UI puisse aussi voir l'erreur
    }
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

  Future<void> updateOrderStatus(int orderId, String status) async {
    final now = DateTime.now();
    await _supabase.from('order_status_histories').insert({
      'order_id': orderId,
      'status': status,
      'created_at': now.toIso8601String(),
    });
    await _supabase.from('orders').update({'updated_at': now.toIso8601String()}).eq('id', orderId);
  }
}
