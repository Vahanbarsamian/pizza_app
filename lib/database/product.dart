import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get basePrice => real()();
  TextColumn get image => text().nullable()();
  TextColumn get category => text().nullable()();
  RealColumn get discountPercentage => real().nullable()();
  BoolColumn get hasGlobalDiscount => boolean().withDefault(const Constant(false))();

  // ✅ NOUVEAU: Ajoute une date de création pour gérer le bandeau "Nouveau"
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
