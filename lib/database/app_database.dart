import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'product.dart';
import 'user.dart';
import 'order.dart';
import 'review.dart';
import 'option.dart';
import 'admin.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Products, Users, Orders, Reviews, ProductOptions, Admins])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 6) {
            await m.addColumn(products, products.createdAt);
          }
        },
      );

  /// ✅ CORRIGÉ: La liste des produits est maintenant triée par date de création descendante.
  Stream<List<Product>> watchAllProducts() {
    return (select(products)..orderBy([ (p) => OrderingTerm(expression: p.createdAt, mode: OrderingMode.desc)])).watch();
  }

  Future<List<Product>> getAllProducts() => select(products).get();
  Future<int> countProducts() => select(products).get().then((x) => x.length);
  Future<void> insertProduct(ProductsCompanion product) =>
      into(products).insert(product);
  Future<void> updateProduct(ProductsCompanion product) =>
      update(products).replace(product);
  Future<void> deleteProduct(ProductsCompanion product) =>
      delete(products).delete(product);

  Stream<List<User>> watchAllUsers() => select(users).watch();
  Future<List<User>> getAllUsers() => select(users).get();

  Stream<List<Order>> watchUserOrders(String userId) =>
      (select(orders)..where((o) => o.userId.equals(userId))).watch();
  Future<List<Order>> getUserOrders(String userId) =>
      (select(orders)..where((o) => o.userId.equals(userId))).get();

  Stream<List<Review>> watchProductReviews(int productId) =>
      (select(reviews)..where((r) => r.productId.equals(productId))).watch();

  Stream<List<ProductOption>> watchProductOptions(int productId) =>
      (select(productOptions)..where((opt) => opt.productId.equals(productId))).watch();

  Future<bool> isAdmin(String userId) async {
    final admin = await (select(admins)..where((a) => a.id.equals(userId))).getSingleOrNull();
    return admin != null;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pizza_app.db'));
    return NativeDatabase(file, logStatements: true);
  });
}
