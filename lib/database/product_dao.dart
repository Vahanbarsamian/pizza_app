import 'package:floor/floor.dart';
import 'product.dart';

@dao
abstract class ProductDao {

  @Query('SELECT * FROM products')
  Future<List<Product>> getAllProducts();

  @insert
  Future<void> insertProduct(Product product);

  @update
  Future<void> updateProduct(Product product);

  @delete
  Future<void> deleteProduct(Product product);

  // ✅ NOUVEAU : Récupérer UN produit par ID
  @Query('SELECT * FROM products WHERE id = :id')
  Future<Product?> getProductById(int id);

  // ✅ NOUVEAU : Appliquer remise GLOBALE à TOUS les produits
  @Query('''
    UPDATE products 
    SET discount_percentage = :percentage, 
        has_global_discount = :applyDiscount
  ''')
  Future<void> applyGlobalDiscount(double percentage, bool applyDiscount);

  // ✅ NOUVEAU : Appliquer remise à un produit spécifique
  @Query('''
    UPDATE products 
    SET discount_percentage = :percentage, 
        has_global_discount = :applyDiscount
    WHERE id = :productId
  ''')
  Future<void> updateProductDiscount(int productId, double percentage, bool applyDiscount);

  // ✅ NOUVEAU : Produits avec remise active seulement
  @Query('SELECT * FROM products WHERE has_global_discount = 1')
  Future<List<Product>> getProductsWithDiscount();

  // ✅ NOUVEAU : Prix moyen des produits (avec remise)
  @Query('''
    SELECT AVG(
      CASE 
        WHEN has_global_discount = 1 AND discount_percentage IS NOT NULL 
        THEN price * (1 - discount_percentage / 100)
        ELSE price 
      END
    ) as averagePrice FROM products
  ''')
  Future<double?> getAveragePrice();

  // ✅ NOUVEAU : Compter produits avec remise
  @Query('SELECT COUNT(*) FROM products WHERE has_global_discount = 1')
  Future<int?> countProductsWithDiscount();
}
