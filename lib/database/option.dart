part of 'app_database.dart';

@DataClassName('ProductOption')
class ProductOptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().nullable().references(Products, #id)();
  TextColumn get name => text()();
  RealColumn get price => real()();

  BoolColumn get isGlobal => boolean().withDefault(const Constant(false))();
  TextColumn get category => text().nullable()();
}
