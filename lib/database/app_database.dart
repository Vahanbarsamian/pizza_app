import 'dart:async';
import 'package:floor/floor.dart';
import 'user.dart';
import 'product.dart';
import 'order.dart';
import 'review.dart';

part 'app_database.g.dart'; // ← Ce fichier sera généré

@Database(version: 1, entities: [User, Product, Order, Review])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ProductDao get productDao;
  OrderDao get orderDao;
  ReviewDao get reviewDao;
}
