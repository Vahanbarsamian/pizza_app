import 'package:drift/drift.dart';

// Drift va utiliser cette définition pour générer la classe 'Product' (Data Class)
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get basePrice => real().named('base_price')();
  TextColumn get image => text().nullable()();
  TextColumn get category => text().nullable()();
  RealColumn get discountPercentage => real().named('discount_percentage').nullable()();
  BoolColumn get hasGlobalDiscount => boolean().named('has_global_discount').withDefault(const Constant(false))();
}
