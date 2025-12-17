part of 'app_database.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().unique()();
  TextColumn get postalCode => text().named('postal_code').nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // ✅ NOUVEAU: ID Client Stripe
  TextColumn get stripeCustomerId => text().named('stripe_customer_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
