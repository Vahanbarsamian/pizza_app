import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';

class SyncService {
  final AppDatabase db;
  final SupabaseClient _supabase = Supabase.instance.client;

  SyncService({required this.db});

  Future<void> syncAll() async {
    await _syncProducts();
    await _syncIngredients();
    await _syncProductIngredientLinks();
    await _syncAnnouncements();
    await _syncCompanyInfo();
    await _syncOrders();
    await _syncOrderItems();
    await _syncOrderStatusHistories(); // ✅ AJOUTÉ
    await _syncReviews();
  }

  // ✅ NOUVELLE MÉTHODE
  Future<void> _syncOrderStatusHistories() async {
    try {
      final response = await _supabase.from('order_status_histories').select();
      final historiesToSync = response.map((item) => OrderStatusHistoriesCompanion.insert(
        id: Value(item['id'] as int),
        orderId: item['order_id'] as int,
        status: item['status'] as String,
        createdAt: DateTime.parse(item['created_at'] as String),
      )).toList();

      await db.transaction(() async {
        await db.delete(db.orderStatusHistories).go();
        await db.batch((batch) => batch.insertAll(db.orderStatusHistories, historiesToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (OrderStatusHistories): $e');
    }
  }

  Future<void> _syncReviews() async {
    try {
      final response = await _supabase.from('reviews').select();
      final reviewsToSync = response.map((item) => ReviewsCompanion.insert(
        id: Value(item['id'] as int),
        orderId: item['order_id'] as int,
        userId: item['user_id'] as String,
        rating: item['rating'] as int,
        comment: Value(item['comment'] as String?),
        createdAt: Value(DateTime.parse(item['created_at'] as String)),
      )).toList();

      await db.transaction(() async {
        await db.delete(db.reviews).go();
        await db.batch((batch) => batch.insertAll(db.reviews, reviewsToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (Reviews): $e');
    }
  }

  Future<void> _syncProducts() async {
    try {
      final response = await _supabase.from('products').select();
      final productsToSync = response.map((item) {
        return ProductsCompanion.insert(
          id: Value(item['id'] as int),
          name: item['name'] as String? ?? 'Nom manquant',
          description: Value(item['description'] as String?),
          basePrice: (item['base_price'] as num? ?? 0).toDouble(),
          image: Value(item['image'] as String?),
          category: Value(item['category'] as String?),
          hasGlobalDiscount: Value(item['has_global_discount'] as bool? ?? false),
          discountPercentage: Value((item['discount_percentage'] as num? ?? 0).toDouble()),
          maxSupplements: Value(item['max_supplements'] as int?),
          createdAt: DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z'),
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

  Future<void> _syncIngredients() async {
    try {
      final response = await _supabase.from('ingredients').select();
      final ingredientsToSync = response.map((item) => IngredientsCompanion.insert(
        id: Value(item['id'] as int),
        name: item['name'] as String? ?? 'Ingrédient inconnu',
        price: (item['price'] as num? ?? 0).toDouble(),
        category: Value(item['category'] as String?),
        isGlobal: Value(item['is_global'] as bool? ?? false),
        createdAt: Value(DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z')),
      )).toList();

      await db.transaction(() async {
        await db.delete(db.ingredients).go();
        await db.batch((batch) => batch.insertAll(db.ingredients, ingredientsToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (Ingredients): $e');
    }
  }

  Future<void> _syncProductIngredientLinks() async {
    try {
      final response = await _supabase.from('product_ingredient_links').select();
      final linksToSync = response.map((item) => ProductIngredientLinksCompanion.insert(
        productId: item['product_id'] as int,
        ingredientId: item['ingredient_id'] as int,
      )).toList();

      await db.transaction(() async {
        await db.delete(db.productIngredientLinks).go();
        await db.batch((batch) => batch.insertAll(db.productIngredientLinks, linksToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (ProductIngredientLinks): $e');
    }
  }

  Future<void> _syncOrders() async {
    try {
      final response = await _supabase.from('orders').select();
      final ordersToSync = response.map((item) => OrdersCompanion.insert(
        id: Value(item['id'] as int),
        userId: item['user_id'] as String,
        total: (item['total'] as num? ?? 0).toDouble(),
        referenceName: Value(item['reference_name'] as String?),
        pickupTime: Value(item['pickup_time'] as String?),
        paymentMethod: Value(item['payment_method'] as String?),
        createdAt: DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z'),
        updatedAt: item['updated_at'] != null ? Value(DateTime.parse(item['updated_at'])) : const Value.absent(),
      )).toList();

      await db.transaction(() async {
        await db.delete(db.orders).go();
        await db.batch((batch) => batch.insertAll(db.orders, ordersToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (Orders): $e');
    }
  }

  Future<void> _syncOrderItems() async {
    try {
      final response = await _supabase.from('order_items').select();
      final itemsToSync = response.map((item) => OrderItemsCompanion.insert(
        id: Value(item['id'] as int),
        orderId: item['order_id'] as int,
        productId: item['product_id'] as int,
        quantity: item['quantity'] as int,
        unitPrice: (item['unit_price'] as num? ?? 0).toDouble(),
        productName: item['product_name'] as String? ?? 'Produit inconnu',
        optionsDescription: Value(item['options_description'] as String?),
      )).toList();

      await db.transaction(() async {
        await db.delete(db.orderItems).go();
        await db.batch((batch) => batch.insertAll(db.orderItems, itemsToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (OrderItems): $e');
    }
  }

  Future<void> _syncAnnouncements() async {
    try {
      final response = await _supabase.from('announcements').select();
      final itemsToSync = response.map((item) => AnnouncementsCompanion.insert(
        id: Value(item['id'] as int),
        title: item['title'] as String? ?? 'Titre manquant',
        announcementText: Value(item['announcement_text'] as String?),
        description: Value(item['description'] as String?),
        imageUrl: Value(item['image_url'] as String?),
        conclusion: Value(item['conclusion'] as String?),
        isActive: Value(item['is_active'] as bool? ?? true),
        type: Value(item['type'] as String? ?? 'Annonce'),
        createdAt: DateTime.parse(item['created_at'] as String? ?? '2023-01-01T00:00:00Z'),
      )).toList();

      await db.transaction(() async {
        await db.delete(db.announcements).go();
        await db.batch((batch) => batch.insertAll(db.announcements, itemsToSync));
      });
    } catch (e) {
      print('❌ Erreur de synchronisation (Announcements): $e');
    }
  }

  Future<void> _syncCompanyInfo() async {
    try {
      final response = await _supabase.from('company_info').select().limit(1);
      if (response.isNotEmpty) {
        final info = response.first;
        final infoToSync = CompanyInfoCompanion.insert(
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
        );
        await db.transaction(() async {
          await db.delete(db.companyInfo).go();
          await db.into(db.companyInfo).insert(infoToSync);
        });
      }
    } catch (e) {
      print('❌ Erreur de synchronisation (CompanyInfo): $e');
    }
  }
}
