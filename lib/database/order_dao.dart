import 'package:floor/floor.dart';
import 'order.dart';

@dao
abstract class OrderDao {
  @Query('SELECT * FROM order')
  Future<List<Order>> getAllOrders();

  @Query('SELECT * FROM order WHERE userId = :userId')
  Future<List<Order>> findOrdersByUserId(int userId);

  @insert
  Future<void> insertOrder(Order order);

  @update
  Future<void> updateOrder(Order order);

  @delete
  Future<void> deleteOrder(Order order);
}
