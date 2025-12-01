import 'package:drift/drift.dart';
import 'user.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ✅ L'ID utilisateur est maintenant un texte pour correspondre à l'UUID de Supabase
  TextColumn get userId => text().references(Users, #id)();
  RealColumn get total => real()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
