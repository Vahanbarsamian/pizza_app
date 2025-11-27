import 'dart:async';
import 'package:floor/floor.dart';
import 'user.dart';
import 'product.dart';
import 'order.dart';
import 'review.dart';
import 'option.dart';  // Import séparé !

part 'app_database.g.dart';

@Database(version: 2, entities: [User, Product, Order, Review, Option])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ProductDao get productDao;
  OrderDao get orderDao;
  ReviewDao get reviewDao;
  OptionDao get optionDao;
}
