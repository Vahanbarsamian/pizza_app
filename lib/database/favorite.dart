part of 'app_database.dart';

@DataClassName('Favorite')
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // On s'assure qu'un utilisateur ne peut pas mettre deux fois le même produit en favori
  @override
  List<Set<Column>> get uniqueKeys => [{userId, productId}];
}
