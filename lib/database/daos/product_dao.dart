part of '../app_database.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(AppDatabase db) : super(db);

  Future<List<Product>> getAllProducts() => select(products).get();
  Stream<List<Product>> watchAllProducts() => select(products).watch();
  Future<void> insertProduct(Product product) => into(products).insert(product);
  Future<void> updateProduct(Product product) => update(products).replace(product);
  Future<void> deleteProduct(Product product) => delete(products).delete(product);

  Future<List<Product>> getProductsWithDiscount() {
    return (select(products)..where((p) => p.hasGlobalDiscount.equals(true))).get();
  }

  Future<double?> getAveragePrice() {
    final avgPrice = products.basePrice.avg(); // Corrected from products.price
    final query = selectOnly(products)..addColumns([avgPrice]);
    return query.map((row) => row.read(avgPrice)).getSingle();
  }

  Future<void> applyGlobalDiscount(double percentage, bool apply) async {
    await (update(products)).write(
      ProductsCompanion(hasGlobalDiscount: Value(apply), discountPercentage: Value(percentage)),
    );
  }
}
