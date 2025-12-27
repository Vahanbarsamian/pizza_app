import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';

class SyncService {
  final AppDatabase db;
  final SupabaseClient _supabase = Supabase.instance.client;

  SyncService({required this.db});

  Future<void> syncAll() async {
    print('ℹ️ [SyncService] Début de la synchronisation complète.');
    await _syncProducts();
    await _syncIngredients();
    await _syncProductIngredientLinks();
    await _syncAnnouncements();
    await _syncCompanyInfo();
    await _syncOrders();
    await _syncOrderItems();
    await _syncOrderStatusHistories();
    await _syncReviews();
    await _syncLoyaltySettings();
    await _syncUserLoyalty();
    await _syncUsers();
    await _syncOpeningHours();
    print('✅ [SyncService] Synchronisation complète terminée.');
  }

  Future<void> _syncProducts() async {
    try {
      final response = await _supabase.from('products').select();
      final productsToSync = response.map((item) {
        return ProductsCompanion(
          id: Value(item['id'] as int),
          name: Value(item['name'] as String? ?? 'Nom manquant'),
          description: Value(item['description'] as String?),
          basePrice: Value((item['base_price'] as num? ?? 0).toDouble()),
          image: Value(item['image'] as String?),
          category: Value(item['category'] as String?),
          hasGlobalDiscount: Value(item['has_global_discount'] as bool? ?? false),
          discountPercentage: Value((item['discount_percentage'] as num? ?? 0).toDouble()),
          maxSupplements: Value(item['max_supplements'] as int?),
          isActive: Value(item['is_active'] as bool? ?? true),
          isDrink: Value(item['is_drink'] as bool? ?? false),
          // ✅ AJOUT : Synchronisation de la rupture de stock
          isOutOfStock: Value(item['is_out_of_stock'] as bool? ?? false),
          createdAt: Value(DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z')),
        );
      }).toList();

      await db.transaction(() async {
        await db.delete(db.products).go();
        await db.batch((batch) => batch.insertAll(db.products, productsToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (Products): $e');
    }
  }

  // Les autres méthodes (_syncOpeningHours, _syncUsers, etc.) restent inchangées...
  Future<void> _syncOpeningHours() async {
    try {
      final response = await _supabase.from('opening_hours').select();
      final hoursToSync = response.map((item) => OpeningHoursCompanion(
        id: Value(item['id'] as int),
        dayName: Value(item['day_name'] as String),
        isOpen: Value(item['is_open'] as bool),
        openTime: Value(item['open_time'] as String),
        closeTime: Value(item['close_time'] as String),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.openingHours).go();
        await db.batch((batch) => batch.insertAll(db.openingHours, hoursToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncUsers() async {
    try {
      final response = await _supabase.from('users').select();
      final usersToSync = response.map((item) => UsersCompanion(
        id: Value(item['id'] as String),
        name: Value(item['name'] as String?),
        email: Value(item['email'] as String),
        postalCode: Value(item['postal_code'] as String?),
        stripeCustomerId: Value(item['stripe_customer_id'] as String?),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.users).go();
        await db.batch((batch) => batch.insertAll(db.users, usersToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncOrders() async {
    try {
      final response = await _supabase.from('orders').select();
      final ordersToSync = response.map((item) {
        return OrdersCompanion(
          id: Value(item['id'] as int),
          userId: Value(item['user_id'] as String),
          total: Value((item['total'] as num? ?? 0).toDouble()),
          referenceName: Value(item['reference_name'] as String?),
          pickupTime: Value(item['pickup_time'] as String?),
          paymentMethod: Value(item['payment_method'] as String?),
          paymentStatus: Value(item['payment_status'] as String? ?? 'pending'),
          isArchived: Value(item['is_archived'] as bool? ?? false),
          createdAt: Value(DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z')),
          updatedAt: item['updated_at'] != null ? Value(DateTime.parse(item['updated_at'])) : const Value.absent(),
        );
      }).toList();
      await db.transaction(() async {
        await db.delete(db.orders).go();
        await db.batch((batch) => batch.insertAll(db.orders, ordersToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncCompanyInfo() async {
    try {
      final response = await _supabase.from('company_info').select().limit(1);
      if (response.isNotEmpty) {
        final info = response.first;
        final infoToSync = CompanyInfoCompanion(
          id: Value(info['id'] as int),
          name: Value(info['name'] as String?),
          presentation: Value(info['presentation'] as String?),
          address: Value(info['address'] as String?),
          phone: Value(info['phone'] as String?),
          email: Value(info['email'] as String?),
          facebookUrl: Value(info['facebook_url'] as String?),
          instagramUrl: Value(info['instagram_url'] as String?),
          xUrl: Value(info['x_url'] as String?),
          whatsappPhone: Value(info['whatsapp_phone'] as String?),
          latitude: Value(info['latitude'] as double?),
          longitude: Value(info['longitude'] as double?),
          ordersEnabled: Value((info['orders_enabled'] as bool?) ?? true),
          closureMessageType: Value(info['closure_message_type'] as String?),
          closureStartDate: info['closure_start_date'] != null ? Value(DateTime.parse(info['closure_start_date'])) : const Value.absent(),
          closureEndDate: info['closure_end_date'] != null ? Value(DateTime.parse(info['closure_end_date'])) : const Value.absent(),
          closureCustomMessage: Value(info['closure_custom_message'] as String?),
          closureScheduleMessage: Value(info['closure_schedule_message'] as String?),
          logoUrl: Value(info['logo_url'] as String?),
          tvaRate: Value((info['tva_rate'] as num?)?.toDouble()),
          googleUrl: Value(info['google_url'] as String?),
          pagesJaunesUrl: Value(info['pagesjaunes_url'] as String?),
          isPaymentEnabled: Value(info['is_payment_enabled'] as bool? ?? false),
        );
        await db.transaction(() async {
          await db.delete(db.companyInfo).go();
          await db.into(db.companyInfo).insert(infoToSync);
        });
      }
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncIngredients() async {
    try {
      final response = await _supabase.from('ingredients').select();
      final ingredientsToSync = response.map((item) => IngredientsCompanion(
        id: Value(item['id'] as int),
        name: Value(item['name'] as String? ?? 'Ingrédient inconnu'),
        price: Value((item['price'] as num? ?? 0).toDouble()),
        category: Value(item['category'] as String?),
        isGlobal: Value(item['is_global'] as bool? ?? false),
        createdAt: Value(DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z')),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.ingredients).go();
        await db.batch((batch) => batch.insertAll(db.ingredients, ingredientsToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncProductIngredientLinks() async {
    try {
      final response = await _supabase.from('product_ingredient_links').select('*, is_base_ingredient');
      final linksToSync = response.map((item) => ProductIngredientLinksCompanion(
        productId: Value(item['product_id'] as int),
        ingredientId: Value(item['ingredient_id'] as int),
        isBaseIngredient: Value(item['is_base_ingredient'] as bool? ?? true),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.productIngredientLinks).go();
        await db.batch((batch) => batch.insertAll(db.productIngredientLinks, linksToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncOrderItems() async {
    try {
      final response = await _supabase.from('order_items').select();
      final itemsToSync = response.map((item) => OrderItemsCompanion(
        id: Value(item['id'] as int),
        orderId: Value(item['order_id'] as int),
        productId: Value(item['product_id'] as int),
        quantity: Value(item['quantity'] as int),
        unitPrice: Value((item['unit_price'] as num? ?? 0).toDouble()),
        productName: Value(item['product_name'] as String? ?? 'Produit inconnu'),
        optionsDescription: Value(item['options_description'] as String?),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.orderItems).go();
        await db.batch((batch) => batch.insertAll(db.orderItems, itemsToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncOrderStatusHistories() async {
    try {
      final response = await _supabase.from('order_status_histories').select();
      final historiesToSync = response.map((item) => OrderStatusHistoriesCompanion(
        id: Value(item['id'] as int),
        orderId: Value(item['order_id'] as int),
        status: Value(item['status'] as String),
        createdAt: Value(DateTime.parse(item['created_at'] as String)),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.orderStatusHistories).go();
        await db.batch((batch) => batch.insertAll(db.orderStatusHistories, historiesToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncReviews() async {
    try {
      final response = await _supabase.from('reviews').select();
      final reviewsToSync = response.map((item) => ReviewsCompanion(
        id: Value(item['id'] as int),
        orderId: Value(item['order_id'] as int),
        userId: Value(item['user_id'] as String),
        rating: Value(item['rating'] as int),
        comment: Value(item['comment'] as String?),
        createdAt: Value(DateTime.parse(item['created_at'] as String)),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.reviews).go();
        await db.batch((batch) => batch.insertAll(db.reviews, reviewsToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncLoyaltySettings() async {
    try {
      final response = await _supabase.from('loyalty_settings').select();
      final settingsToSync = response.map((item) => LoyaltySettingsCompanion(
        id: Value(item['id'] as int),
        isEnabled: Value(item['is_enabled'] as bool? ?? false),
        mode: Value(item['mode'] as String? ?? 'free_pizza'),
        threshold: Value(item['threshold'] as int? ?? 10),
        discountPercentage: Value((item['discount_percentage'] as num? ?? 0.1).toDouble()),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.loyaltySettings).go();
        await db.batch((batch) => batch.insertAll(db.loyaltySettings, settingsToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncUserLoyalty() async {
    try {
      final response = await _supabase.from('user_loyalty').select();
      final loyaltyDataToSync = response.map((item) => UserLoyaltiesCompanion(
        userId: Value(item['user_id'] as String),
        pizzaCount: Value(item['pizza_count'] as int? ?? 0),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.userLoyalties).go();
        await db.batch((batch) => batch.insertAll(db.userLoyalties, loyaltyDataToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }

  Future<void> _syncAnnouncements() async {
    try {
      final response = await _supabase.from('announcements').select();
      final itemsToSync = response.map((item) => AnnouncementsCompanion(
        id: Value(item['id'] as int),
        title: Value(item['title'] as String? ?? 'Titre manquant'),
        announcementText: Value(item['announcement_text'] as String?),
        description: Value(item['description'] as String?),
        imageUrl: Value(item['image_url'] as String?),
        conclusion: Value(item['conclusion'] as String?),
        isActive: Value(item['is_active'] as bool? ?? true),
        type: Value(item['type'] as String? ?? 'Annonce'),
        createdAt: Value(DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z')),
      )).toList();
      await db.transaction(() async {
        await db.delete(db.announcements).go();
        await db.batch((batch) => batch.insertAll(db.announcements, itemsToSync));
      });
    } catch (e) { print('❌ Erreur: $e'); }
  }
}
