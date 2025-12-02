import 'package:drift/drift.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get basePrice => real().named('base_price')();
  TextColumn get image => text().nullable()();
  TextColumn get category => text()();
  RealColumn get discountPercentage => real().named('discount_percentage').withDefault(const Constant(0.0))();
  BoolColumn get hasGlobalDiscount => boolean().named('has_global_discount').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  // ✅ NOUVEAU: Limite de suppléments pour une pizza
  IntColumn get maxSupplements => integer().named('max_supplements').nullable()();
}
