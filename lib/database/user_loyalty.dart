import 'package:drift/drift.dart';

// Définition de la table pour suivre les points de fidélité de chaque utilisateur
@DataClassName('UserLoyalty')
class UserLoyalties extends Table {
  TextColumn get userId => text().named('user_id')();
  IntColumn get pizzaCount => integer().named('pizza_count').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {userId};
}
