import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'product.dart';
import 'user.dart';
import 'order.dart';
import 'review.dart';
import 'ingredient.dart';
import 'admin.dart';
import 'announcement.dart';
import 'company_info.dart';
import 'product_ingredient_link.dart';
import 'saved_cart_item.dart';

part 'app_database.g.dart';

class ReviewWithOrder {
  final Review review;
  final Order order;
  ReviewWithOrder({required this.review, required this.order});
}

class OrderWithStatus {
  final Order order;
  final String status;
  OrderWithStatus({required this.order, required this.status});
}

@DriftDatabase(tables: [
  Products,
  Users,
  Orders,
  OrderItems,
  Reviews,
  Ingredients,
  Admins,
  Announcements,
  CompanyInfo,
  ProductIngredientLinks,
  SavedCartItems,
  OrderStatusHistories,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 26;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
          }
          await m.createAll();
        },
      );
      
  Stream<List<OrderWithStatus>> _watchOrdersWithStatus(String? userId) {
    final baseSql = '''
      SELECT o.*, COALESCE(latest.status, \'À faire\') as status
      FROM orders o
      LEFT JOIN (
        SELECT order_id, status, MAX(created_at) as max_date
        FROM order_status_histories
        GROUP BY order_id
      ) latest ON o.id = latest.order_id
    ''';

    String sql;
    List<Variable> variables = [];
    if (userId != null) {
      sql = '$baseSql WHERE o.user_id = ? ORDER BY o.updated_at DESC, o.created_at DESC';
      variables.add(Variable.withString(userId));
    } else {
      sql = '$baseSql ORDER BY o.updated_at DESC, o.created_at DESC';
    }

    return customSelect(sql, variables: variables, readsFrom: { orders, orderStatusHistories }).map((row) {
      return OrderWithStatus(
        order: orders.map(row.data),
        status: row.read<String>('status'),
      );
    }).watch();
  }

  Stream<List<OrderWithStatus>> watchAllOrdersWithStatus() => _watchOrdersWithStatus(null);
  Stream<List<OrderWithStatus>> watchUserOrdersWithStatus(String userId) => _watchOrdersWithStatus(userId);

  Future<List<Order>> getArchivedOrders(DateTime? start, DateTime? end) {
    var query = select(orders)..where((o) => o.isArchived.equals(true));

    if (start != null) {
      // ✅ CORRECTION FINALE ET ABSOLUE
      query.where((o) => o.createdAt.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      final endOfDay = DateTime(end.year, end.month, end.day + 1);
      query.where((o) => o.createdAt.isSmallerThanValue(endOfDay));
    }

    query.orderBy([(o) => OrderingTerm(expression: o.createdAt, mode: OrderingMode.desc)]);

    return query.get();
  }

  Future<List<SavedCartItem>> getAllSavedCartItems() => select(savedCartItems).get();
  Future<void> saveCartItem(SavedCartItemsCompanion item) => into(savedCartItems).insert(item, mode: InsertMode.replace);
  Future<void> deleteCartItem(String uniqueId) => (delete(savedCartItems)..where((tbl) => tbl.uniqueId.equals(uniqueId))).go();
  Future<void> clearSavedCart() => delete(savedCartItems).go();

  Stream<List<ReviewWithOrder>> watchUserReviews(String userId) {
    final query = select(reviews).join([innerJoin(orders, orders.id.equalsExp(reviews.orderId))])..where(reviews.userId.equals(userId))..orderBy([OrderingTerm(expression: reviews.createdAt, mode: OrderingMode.desc)]);
    return query.watch().map((rows) => rows.map((row) => ReviewWithOrder(review: row.readTable(reviews),order: row.readTable(orders))).toList());
  }

  Stream<Review?> watchReviewForOrder(int orderId) => (select(reviews)..where((r) => r.orderId.equals(orderId))).watchSingleOrNull();
  Stream<List<ReviewWithOrder>> watchAllPublicReviews() {
    final query = select(reviews).join([innerJoin(orders, orders.id.equalsExp(reviews.orderId))])..orderBy([OrderingTerm(expression: reviews.createdAt, mode: OrderingMode.desc)]);
    return query.watch().map((rows) => rows.map((row) => ReviewWithOrder(review: row.readTable(reviews),order: row.readTable(orders))).toList());
  }

  Stream<List<Announcement>> watchAllAnnouncementsForAdmin() => (select(announcements)..orderBy([(a) => OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)])).watch();
  Stream<List<Announcement>> watchAllAnnouncements() => (select(announcements)..where((a) => a.isActive.equals(true))..orderBy([(a) => OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)])).watch();
  Stream<List<Product>> watchAllProducts() => (select(products)..orderBy([(p) => OrderingTerm(expression: p.createdAt, mode: OrderingMode.desc)])).watch();
  Stream<List<Ingredient>> watchAllIngredients() => select(ingredients).watch();
  Stream<List<Ingredient>> watchIngredientsForProduct(int productId) {
    final specificIngredientsQuery = select(productIngredientLinks).join([innerJoin(ingredients, ingredients.id.equalsExp(productIngredientLinks.ingredientId))])..where(productIngredientLinks.productId.equals(productId));
    final globalIngredientsQuery = select(ingredients)..where((i) => i.isGlobal.equals(true));
    final specificStream = specificIngredientsQuery.map((row) => row.readTable(ingredients)).watch();
    final globalStream = globalIngredientsQuery.watch();
    return specificStream.asyncMap((specific) async {
      final globals = await globalStream.first;
      final all = {...specific, ...globals}.toList();
      all.sort((a, b) => a.name.compareTo(b.name));
      return all;
    });
  }
  
  Future<List<OrderItem>> getOrderItems(int orderId) => (select(orderItems)..where((item) => item.orderId.equals(orderId))).get();
  Stream<CompanyInfoData?> watchCompanyInfo() => select(companyInfo).watchSingleOrNull();
  Future<bool> isAdmin(String userId) async {
    final admin = await (select(admins)..where((a) => a.id.equals(userId))).getSingleOrNull();
    return admin != null;
  }

  Future<List<Product>> getAllProducts() => select(products).get();
  Future<List<Ingredient>> getAllIngredients() => select(ingredients).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pizza_app.db'));
    return NativeDatabase(file, logStatements: true);
  });
}
