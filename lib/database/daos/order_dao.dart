import 'package:floor/floor.dart';
import '../order.dart';

@dao
abstract class OrderDao {
  @Query('SELECT * FROM `Order`')
  Future<List<Order>> getAllOrders();

  @insert
  Future<int?> insertOrder(Order order);     // ✅ int?

  @update
  Future<int> updateOrder(Order order);      // ✅ int

  @delete
  Future<int> deleteOrder(Order order);      // ✅ int
}