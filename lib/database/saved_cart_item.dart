import 'package:drift/drift.dart';

// Table pour sauvegarder les articles du panier localement
@DataClassName('SavedCartItem')
class SavedCartItems extends Table {
  // Clé unique pour un produit + sa combinaison d'ingrédients
  // ex: '1-2-5' (pizza id 1 avec ingrédients 2 et 5)
  TextColumn get uniqueId => text()();

  IntColumn get productId => integer().named('product_id')();
  IntColumn get quantity => integer()();

  // Les IDs des ingrédients seront stockés sous forme de texte, séparés par des virgules
  // ex: '2,5'
  TextColumn get selectedIngredients => text().named('selected_ingredients')();

  @override
  Set<Column> get primaryKey => {uniqueId};
}
