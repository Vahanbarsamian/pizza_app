/*import 'package:floor/floor.dart';
import '../option.dart';
//import 'dao/app_database.dart';

@dao
abstract class OptionDao {
  @Query('SELECT * FROM options WHERE product_id = :productId AND is_active = 1')
  Future<List<Option>> getOptionsForProduct(int productId);

  @Query('SELECT * FROM options WHERE is_active = 1')
  Future<List<Option>> getAllActiveOptions();

  @insert
  Future<void> insertOption(Option option);

  @update
  Future<void> updateOption(Option option);

  @delete
  Future<void> deleteOption(Option option);

  @Query('DELETE FROM options WHERE product_id = :productId')
  Future<void> deleteOptionsForProduct(int productId);
  // ✅ BONUS : Compter options par produit (utile pour UI)
  @Query('SELECT COUNT(*) FROM options WHERE product_id = :productId AND is_active = 1')
  Future<int?> countOptionsForProduct(int productId);
}

 */