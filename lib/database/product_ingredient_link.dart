part of 'app_database.dart';

@DataClassName('ProductIngredientLink')
class ProductIngredientLinks extends Table {
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  BoolColumn get isBaseIngredient => boolean().named('is_base_ingredient').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {productId, ingredientId};
}
