import 'package:floor/floor.dart';
import '../product.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM products')
  Future<List<Product>> getAllProducts();

  @Query('SELECT * FROM products WHERE id = :id')
  Future<Product?> getProductById(int id);

  @insert
  Future<int?> insertProduct(Product product);  // ✅ int?

  @update
  Future<int> updateProduct(Product product);   // ✅ int

  @delete
  Future<int> deleteProduct(Product product);   // ✅ int
}
