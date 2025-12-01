import 'package:drift/drift.dart';
import 'product.dart';

// ✅ Renommée pour éviter le conflit avec le nom réservé 'options' de Drift
class ProductOptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get name => text()();
  RealColumn get price => real()();

  // On renomme la table dans la base de données pour garder le nom 'options'
  @override
  String get tableName => 'options';
}
