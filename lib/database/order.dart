import 'package:drift/drift.dart';

// Table pour les informations générales de la commande
@DataClassName('Order')
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get referenceName => text().named('reference_name').nullable()();
  TextColumn get pickupTime => text().named('pickup_time').nullable()();
  TextColumn get paymentMethod => text().named('payment_method').nullable()(); 
  RealColumn get total => real().named('total')();
  TextColumn get status => text().withDefault(const Constant('À faire'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
}

// Table pour les articles spécifiques d'une commande
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
