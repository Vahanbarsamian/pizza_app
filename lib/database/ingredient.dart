part of 'app_database.dart';

@DataClassName('Ingredient')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get category => text().nullable()();
  // ✅ NOUVEAU: Colonne pour l'ingrédient global
  BoolColumn get isGlobal => boolean().named('is_global').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}
