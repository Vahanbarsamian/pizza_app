import 'package:drift/drift.dart';
import 'product.dart';
import 'user.dart';

class Reviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  // ✅ L'ID utilisateur est maintenant un texte pour correspondre à l'UUID de Supabase
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get rating => integer()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
