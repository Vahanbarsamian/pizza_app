import 'package:drift/drift.dart';

@DataClassName('Order')
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get referenceName => text().named('reference_name').nullable()();
  TextColumn get pickupTime => text().named('pickup_time').nullable()();
  TextColumn get paymentMethod => text().named('payment_method').nullable()(); 
  RealColumn get total => real().named('total')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();
  // ✅ CORRIGÉ: Colonne rendue nullable pour la compatibilité
  BoolColumn get isArchived => boolean().named('is_archived').nullable()();
}

@DataClassName('OrderItem')
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().named('order_id').references(Orders, #id)();
  IntColumn get productId => integer().named('product_id')();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real().named('unit_price')();
  TextColumn get productName => text().named('product_name')();
  TextColumn get optionsDescription => text().named('options_description').nullable()();
}

@DataClassName('OrderStatusHistory')
class OrderStatusHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().named('order_id').references(Orders, #id)();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
}
