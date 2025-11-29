import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'user.dart';
import 'product.dart';
import 'order.dart';
import 'review.dart';
import 'option.dart';
import 'daos/user_dao.dart';
import 'daos/product_dao.dart';
import 'daos/order_dao.dart';
import 'daos/review_dao.dart';
import 'daos/option_dao.dart';

part 'app_database.g.dart'; // ← OBLIGATOIRE

@Database(version: 2, entities: [User, Product, Order, Review, Option])
abstract class AppDatabase extends FloorDatabase {
  // ← EXACTEMENT FloorDatabase (pas autre chose !)

  UserDao get userDao;
  ProductDao get productDao;
  OrderDao get orderDao;
  ReviewDao get reviewDao;
  OptionDao get optionDao;
}
