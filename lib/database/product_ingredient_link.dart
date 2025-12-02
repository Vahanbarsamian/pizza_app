import 'package:drift/drift.dart';
import 'product.dart';
import 'ingredient.dart'; // ✅ CORRIGÉ: Fait référence au bon fichier

@DataClassName('ProductIngredientLink')
class ProductIngredientLinks extends Table {
  IntColumn get productId => integer().references(Products, #id)();
  // ✅ CORRIGÉ: La colonne et la référence sont correctes
  IntColumn get ingredientId => integer().references(Ingredients, #id)();

  @override
  Set<Column> get primaryKey => {productId, ingredientId};
}
