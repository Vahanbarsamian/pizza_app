part of 'app_database.dart';

@DataClassName('OpeningHour')
class OpeningHours extends Table {
  IntColumn get id => integer()(); // 1 pour Lundi, 7 pour Dimanche
  TextColumn get dayName => text()();
  BoolColumn get isOpen => boolean().withDefault(const Constant(true))();
  TextColumn get openTime => text().withDefault(const Constant('11:00'))();
  TextColumn get closeTime => text().withDefault(const Constant('22:00'))();

  @override
  Set<Column> get primaryKey => {id};
}
