import 'package:drift/drift.dart';
import 'order.dart';
import 'user.dart';

// ✅ CORRIGÉ: La table des avis est maintenant liée à la table Orders
class Reviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().named('order_id').references(Orders, #id)();
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get rating => integer()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}
