part of 'app_database.dart';

@DataClassName('ProductOptionLink')
class ProductOptionLinks extends Table {
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get optionId => integer().references(ProductOptions, #id)();

  @override
  Set<Column> get primaryKey => {productId, optionId};
}
