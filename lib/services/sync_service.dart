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
    await _syncReviews();
  }

  Future<void> _syncReviews() async {
    final response = await _supabase.from('reviews').select();
    final reviewsToSync = response.map((item) => ReviewsCompanion.insert(
        id: Value(item['id']),
        orderId: item['order_id'],
        userId: item['user_id'],
        rating: item['rating'],
        comment: Value(item['comment']),
        createdAt: Value(DateTime.parse(item['created_at'])),
    )).toList();

    await db.transaction(() async {
      await db.delete(db.reviews).go();
      await db.batch((batch) {
        batch.insertAll(db.reviews, reviewsToSync);
      });
    });
  }

  Future<void> _syncProducts() async {
    final response = await _supabase.from('products').select();
    final productsToSync = response.map((item) => ProductsCompanion.insert(
        id: Value(item['id']),
        name: item['name'],
        description: Value(item['description']),
        image: Value(item['image']),
        basePrice: item['base_price'],
        discountPercentage: Value(item['discount_percentage'] ?? 0.0),
        maxSupplements: Value(item['max_supplements'] ?? 4),
        category: Value(item['category']),
        createdAt: DateTime.parse(item['created_at']),
    )).toList();

    await db.transaction(() async {
      await db.delete(db.products).go();
      await db.batch((batch) {
        batch.insertAll(db.products, productsToSync);
      });
    });
  }

  Future<void> _syncIngredients() async {
    final response = await _supabase.from('ingredients').select();
    final ingredientsToSync = response.map((item) => IngredientsCompanion.insert(
        id: Value(item['id']),
        name: item['name'],
        price: item['price'],
        category: Value(item['category']),
        isGlobal: Value(item['is_global'] ?? false),
        createdAt: Value(DateTime.parse(item['created_at'])),
    )).toList();

    await db.transaction(() async {
      await db.delete(db.ingredients).go();
      await db.batch((batch) {
        batch.insertAll(db.ingredients, ingredientsToSync);
      });
    });
  }

  Future<void> _syncProductIngredientLinks() async {
    final response = await _supabase.from('product_ingredient_links').select();
    final linksToSync = response.map((item) => ProductIngredientLinksCompanion.insert(
        productId: item['product_id'],
        ingredientId: item['ingredient_id'],
    )).toList();

    await db.transaction(() async {
      await db.delete(db.productIngredientLinks).go();
      await db.batch((batch) {
        batch.insertAll(db.productIngredientLinks, linksToSync);
      });
    });
  }

  Future<void> _syncOrders() async {
    final response = await _supabase.from('orders').select();
    final ordersToSync = response.map((item) => OrdersCompanion.insert(
        id: Value(item['id']),
        userId: item['user_id'],
        total: item['total'] is int ? (item['total'] as int).toDouble() : item['total'],
        referenceName: Value(item['reference_name']),
        pickupTime: Value(item['pickup_time']),
        paymentMethod: Value(item['payment_method']),
        createdAt: DateTime.parse(item['created_at']),
    )).toList();

    await db.transaction(() async {
      await db.delete(db.orders).go();
      await db.batch((batch) {
        batch.insertAll(db.orders, ordersToSync);
      });
    });
  }

  Future<void> _syncOrderItems() async {
    final response = await _supabase.from('order_items').select();
    final itemsToSync = response.map((item) => OrderItemsCompanion.insert(
        id: Value(item['id']),
        orderId: item['order_id'],
        productId: item['product_id'],
        quantity: item['quantity'],
        unitPrice: item['unit_price'] is int ? (item['unit_price'] as int).toDouble() : item['unit_price'],
        productName: item['product_name'],
        optionsDescription: Value(item['options_description']),
    )).toList();

    await db.transaction(() async {
      await db.delete(db.orderItems).go();
      await db.batch((batch) {
        batch.insertAll(db.orderItems, itemsToSync);
      });
    });
  }

  Future<void> _syncAnnouncements() async {
    final response = await _supabase.from('announcements').select();
    final itemsToSync = response.map((item) => AnnouncementsCompanion.insert(
        id: Value(item['id']),
        title: item['title'],
        announcementText: Value(item['announcement_text']),
        description: Value(item['description']),
        imageUrl: Value(item['image_url']),
        conclusion: Value(item['conclusion']),
        isActive: Value(item['is_active'] ?? true),
        type: Value(item['type'] ?? 'Annonce'),
        createdAt: DateTime.parse(item['created_at']),
    )).toList();

    await db.transaction(() async {
      await db.delete(db.announcements).go();
      await db.batch((batch) {
        batch.insertAll(db.announcements, itemsToSync);
      });
    });
  }

  Future<void> _syncCompanyInfo() async {
    final response = await _supabase.from('company_info').select().limit(1);
    if (response.isNotEmpty) {
      final info = response.first;
      final infoToSync = CompanyInfoCompanion.insert(
        id: Value(info['id']),
        name: Value(info['name']),
        presentation: Value(info['presentation']),
        address: Value(info['address']),
        phone: Value(info['phone']),
        email: Value(info['email']),
        facebookUrl: Value(info['facebook_url']),
        instagramUrl: Value(info['instagram_url']),
        xUrl: Value(info['x_url']),
        whatsappPhone: Value(info['whatsapp_phone']),
        latitude: Value(info['latitude']),
        longitude: Value(info['longitude']),
      );
      await db.transaction(() async {
        await db.delete(db.companyInfo).go();
        await db.into(db.companyInfo).insert(infoToSync);
      });
    }
  }
}
