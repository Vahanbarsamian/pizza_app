import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'user.dart';
import 'product.dart';
import 'order.dart';
import 'review.dart';
import 'option.dart';  // Import séparé !

import 'user_dao.dart';
import 'product_dao.dart';
import 'order_dao.dart';
import 'review_dao.dart';
import 'option_dao.dart';

part 'app_database.g.dart';

@Database(version: 2, entities: [User, Product, Order, Review, Option])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ProductDao get productDao;
  OrderDao get orderDao;
  ReviewDao get reviewDao;
  OptionDao get optionDao;
}
