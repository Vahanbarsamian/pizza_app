part of 'app_database.dart';

class OrderStatusHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().named('order_id').references(Orders, #id)();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
}
