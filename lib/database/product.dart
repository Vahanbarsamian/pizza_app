import 'package:drift/drift.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
  RealColumn get basePrice => real().named('base_price')();
  RealColumn get discountPercentage => real().named('discount_percentage').withDefault(const Constant(0.0))();
  IntColumn get maxSupplements => integer().named('max_supplements').nullable()();
  // ✅ CORRIGÉ: La catégorie est maintenant optionnelle (nullable)
  TextColumn get category => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
}
