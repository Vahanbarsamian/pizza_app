part of 'app_database.dart';

// La table 'admins' liste les utilisateurs ayant des droits d'administration.
// La clé primaire est l'UUID de l'utilisateur dans Supabase Auth.
@DataClassName('Admin')
class Admins extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get role => text().withDefault(const Constant('admin'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
