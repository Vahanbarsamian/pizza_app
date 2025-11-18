import 'dao/user_dao.dart';
import 'dao/product_dao.dart';
import 'dao/order_dao.dart';
import 'dao/review_dao.dart';

@Database(version: 1, entities: [User, Product, Order, Review])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ProductDao get productDao;
  OrderDao get orderDao;
  ReviewDao get reviewDao;
}
