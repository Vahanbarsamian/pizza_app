import 'package:floor/floor.dart';
import '../product.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM Product')
  Future<List<Product>> getAllProducts();

  @insert
  Future<void> insertProduct(Product product);

  @update
  Future<void> updateProduct(Product product);

  @delete
  Future<void> deleteProduct(Product product);
}
