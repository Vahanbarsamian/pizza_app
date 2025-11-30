import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'product.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Ancienne méthode qui ne renvoie les données qu'une seule fois
  Future<List<Product>> getAllProducts() => select(products).get();

  // ✅ NOUVEAU: Renvoie un flux de données qui se met à jour automatiquement
  Stream<List<Product>> watchAllProducts() => select(products).watch();

  Future<int> countProducts() async {
    final all = await getAllProducts();
    return all.length;
  }

  Future<void> insertProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Future<void> updateProduct(ProductsCompanion product) =>
      update(products).replace(product);

  Future<void> deleteProduct(ProductsCompanion product) =>
      delete(products).delete(product);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pizza_app.db'));
    return NativeDatabase(file);
  });
}
