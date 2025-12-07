import 'package:drift/drift.dart';
import 'product.dart';
import 'ingredient.dart';

@DataClassName('ProductIngredientLink')
class ProductIngredientLinks extends Table {
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  
  // ✅ AJOUTÉ: Colonne pour différencier les ingrédients de base des suppléments
  BoolColumn get isBaseIngredient => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {productId, ingredientId};
}
