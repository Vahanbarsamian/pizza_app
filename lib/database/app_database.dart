import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'product.dart';
import 'user.dart';
import 'order.dart';
import 'review.dart';
import 'ingredient.dart';
import 'admin.dart';
import 'announcement.dart';
import 'company_info.dart';
import 'product_ingredient_link.dart';
import 'saved_cart_item.dart';

part 'app_database.g.dart';

class ReviewWithOrder {
  final Review review;
  final Order order;
  ReviewWithOrder({required this.review, required this.order});
}

@DriftDatabase(tables: [
  Products,
  Users,
  Orders,
  OrderItems,
  Reviews,
  Ingredients,
  Admins,
  Announcements,
  CompanyInfo,
  ProductIngredientLinks,
  SavedCartItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 21;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
          }
          await m.createAll();
        },
      );

  // --- REQUÊTES PANIER LOCAL ---
  Future<List<SavedCartItem>> getAllSavedCartItems() => select(savedCartItems).get();
  Future<void> saveCartItem(SavedCartItemsCompanion item) => into(savedCartItems).insert(item, mode: InsertMode.replace);
  // ✅ CORRIGÉ: Renommage de la fonction pour correspondre aux appels
  Future<void> deleteCartItem(String uniqueId) => (delete(savedCartItems)..where((tbl) => tbl.uniqueId.equals(uniqueId))).go();
  Future<void> clearSavedCart() => delete(savedCartItems).go();

  // --- REQUÊTES AVIS ---
  Stream<List<ReviewWithOrder>> watchUserReviews(String userId) {
    final query = select(reviews).join([
      innerJoin(orders, orders.id.equalsExp(reviews.orderId))
    ])..where(reviews.userId.equals(userId))
      ..orderBy([OrderingTerm(expression: reviews.createdAt, mode: OrderingMode.desc)]);

    return query.watch().map((rows) => rows.map((row) {
      return ReviewWithOrder(
        review: row.readTable(reviews),
        order: row.readTable(orders),
      );
    }).toList());
  }

  Stream<Review?> watchReviewForOrder(int orderId) {
    return (select(reviews)..where((r) => r.orderId.equals(orderId))).watchSingleOrNull();
  }

  Stream<List<ReviewWithOrder>> watchAllPublicReviews() {
    final query = select(reviews).join([
      innerJoin(orders, orders.id.equalsExp(reviews.orderId))
    ])..orderBy([OrderingTerm(expression: reviews.createdAt, mode: OrderingMode.desc)]);

    return query.watch().map((rows) => rows.map((row) {
      return ReviewWithOrder(
        review: row.readTable(reviews),
        order: row.readTable(orders),
      );
    }).toList());
  }

  // --- AUTRES REQUÊTES ---
  Stream<List<Product>> watchAllProducts() => (select(products)..orderBy([(p) => OrderingTerm(expression: p.createdAt, mode: OrderingMode.desc)])).watch();
  Stream<List<Ingredient>> watchAllIngredients() => select(ingredients).watch();
  Stream<List<Ingredient>> watchIngredientsForProduct(int productId) {
    final specificIngredientsQuery = select(productIngredientLinks).join([
      innerJoin(ingredients, ingredients.id.equalsExp(productIngredientLinks.ingredientId))
    ])
      ..where(productIngredientLinks.productId.equals(productId));

    final globalIngredientsQuery = select(ingredients)..where((i) => i.isGlobal.equals(true));

    final specificStream = specificIngredientsQuery.map((row) => row.readTable(ingredients)).watch();
    final globalStream = globalIngredientsQuery.watch();

    return specificStream.asyncMap((specific) async {
      final globals = await globalStream.first;
      final all = {...specific, ...globals}.toList();
      all.sort((a, b) => a.name.compareTo(b.name));
      return all;
    });
  }
  
  Stream<List<Order>> watchUserOrders(String userId) {
    return (select(orders)..where((o) => o.userId.equals(userId))..orderBy([(o) => OrderingTerm(expression: o.createdAt, mode: OrderingMode.desc)])).watch();
  }

  Future<List<OrderItem>> getOrderItems(int orderId) {
    return (select(orderItems)..where((item) => item.orderId.equals(orderId))).get();
  }

  Stream<List<Announcement>> watchAllAnnouncements() => (select(announcements)..where((a) => a.isActive.equals(true))..orderBy([(a) => OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)])).watch();
  Stream<CompanyInfoData> watchCompanyInfo() => select(companyInfo).watchSingle();
  Future<bool> isAdmin(String userId) async {
    final admin = await (select(admins)..where((a) => a.id.equals(userId))).getSingleOrNull();
    return admin != null;
  }

  Future<List<Product>> getAllProducts() => select(products).get();
  Future<List<Ingredient>> getAllIngredients() => select(ingredients).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pizza_app.db'));
    return NativeDatabase(file, logStatements: true);
  });
}
