part of 'app_database.dart';

// La table Users est maintenant liée aux utilisateurs de Supabase Auth
class Users extends Table {
  // L'ID est maintenant un UUID (Texte) de Supabase, et non plus un entier auto-incrémenté.
  TextColumn get id => text()();

  TextColumn get name => text().nullable()();
  TextColumn get email => text().unique()();
  TextColumn get postalCode => text().named('postal_code').nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
