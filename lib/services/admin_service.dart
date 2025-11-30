import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import '../database/app_database.dart';

// Le service dépend maintenant directement de la base de données
class AdminService {
  final AppDatabase db;

  AdminService({required this.db});

  Future<void> addPizza({
    required String name,
    required double price,
    String image = '',
    String category = 'pizza',
    double discount = 0.0,
    bool hasGlobalDiscount = false,
  }) async {
    final product = ProductsCompanion.insert(
      name: name,
      basePrice: price,
      image: image.isEmpty
          ? Value('https://via.placeholder.com/150?text=$name')
          : Value(image),
      category: Value(category),
      discountPercentage: Value(discount),
      hasGlobalDiscount: Value(hasGlobalDiscount),
    );
    await db.insertProduct(product);
    debugPrint('✅ Admin: Pizza ajoutée $name ($price€)');
  }

  Future<int> getPizzaCount() async {
    return await db.countProducts();
  }
}
