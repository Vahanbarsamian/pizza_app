import 'package:drift/drift.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real()();
  TextColumn get image => text().nullable()();
  BoolColumn get hasGlobalDiscount => boolean().withDefault(const Constant(false))();
  RealColumn get discountPercentage => real().nullable()();
}
