import 'package:drift/drift.dart';

// Définition de la table pour les paramètres de fidélité
@DataClassName('LoyaltySetting')
class LoyaltySettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get isEnabled => boolean().named('is_enabled').withDefault(const Constant(false))();
  TextColumn get mode => text().withDefault(const Constant('free_pizza'))(); // 'free_pizza' or 'discount'
  IntColumn get threshold => integer().withDefault(const Constant(10))();
  RealColumn get discountPercentage => real().named('discount_percentage').withDefault(const Constant(0.1))();

  @override
  Set<Column> get primaryKey => {id};
}
