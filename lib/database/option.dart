import 'package:drift/drift.dart';
import 'product.dart'; // ✅ CORRIGÉ: L'import manquant a été ajouté.

@DataClassName('ProductOption')
class ProductOptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  // La référence à 'Products' est maintenant comprise grâce à l'import.
  IntColumn get productId => integer().nullable().references(Products, #id)();
  TextColumn get name => text()();
  RealColumn get price => real()();

  BoolColumn get isGlobal => boolean().withDefault(const Constant(false))();
  TextColumn get category => text().nullable()();
}
