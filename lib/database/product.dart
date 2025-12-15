part of 'app_database.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get basePrice => real().named('base_price')();
  TextColumn get image => text().nullable()();
  TextColumn get category => text().nullable()();
  BoolColumn get hasGlobalDiscount => boolean().named('has_global_discount').withDefault(const Constant(false))();
  RealColumn get discountPercentage => real().named('discount_percentage').withDefault(const Constant(0.0))();
  IntColumn get maxSupplements => integer().named('max_supplements').nullable()();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  // ✅ AJOUT: Colonne pour identifier les boissons
  BoolColumn get isDrink => boolean().named('is_drink').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
