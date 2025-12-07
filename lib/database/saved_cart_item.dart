import 'package:drift/drift.dart';

@DataClassName('SavedCartItem')
class SavedCartItems extends Table {
  TextColumn get uniqueId => text()();

  IntColumn get productId => integer().named('product_id')();
  IntColumn get quantity => integer()();

  TextColumn get selectedIngredients => text().named('selected_ingredients')();

  // ✅ AJOUTÉ: Nouvelle colonne pour les ingrédients retirés
  TextColumn get removedIngredients => text().named('removed_ingredients').withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {uniqueId};
}
