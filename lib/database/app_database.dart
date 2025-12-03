import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import des modèles de table
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
  int get schemaVersion => 18;

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

  // ✅ CORRIGÉ: Ré-ajout des méthodes de gestion du panier
  Future<List<SavedCartItem>> getAllSavedCartItems() => select(savedCartItems).get();
  Future<void> saveCartItem(SavedCartItemsCompanion item) => into(savedCartItems).insert(item, mode: InsertMode.replace);
  Future<void> deleteCartItem(String uniqueId) => (delete(savedCartItems)..where((tbl) => tbl.uniqueId.equals(uniqueId))).go();
  Future<void> clearSavedCart() => delete(savedCartItems).go();


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
  
  Stream<List<Review>> watchProductReviews(int productId) => (select(reviews)..where((r) => r.productId.equals(productId))).watch();

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
