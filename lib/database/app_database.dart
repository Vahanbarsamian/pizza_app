import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import des modèles de table
import 'product.dart';
import 'user.dart';
import 'order.dart';
import 'review.dart';
import 'ingredient.dart';
import 'admin.dart';
import 'announcement.dart';
import 'company_info.dart';
import 'product_ingredient_link.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Products,
  Users,
  Orders,
  Reviews,
  Ingredients,
  Admins,
  Announcements,
  CompanyInfo,
  ProductIngredientLinks,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 15; // Version incrémentée

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

  // --- Requêtes --- 

  Stream<List<Product>> watchAllProducts() => (select(products)..orderBy([(p) => OrderingTerm(expression: p.createdAt, mode: OrderingMode.desc)])).watch();
  
  Stream<List<Ingredient>> watchAllIngredients() => select(ingredients).watch();

  Stream<List<Ingredient>> watchIngredientsForProduct(int productId) {
    final specificIngredients = select(productIngredientLinks).join([
      innerJoin(ingredients, ingredients.id.equalsExp(productIngredientLinks.ingredientId))
    ])
      ..where(productIngredientLinks.productId.equals(productId));

    final globalIngredients = select(ingredients)..where((i) => i.isGlobal.equals(true));

    final specificStream = specificIngredients.map((row) => row.readTable(ingredients)).watch();
    final globalStream = globalIngredients.watch();

    return specificStream.asyncMap((specific) async {
      final globals = await globalStream.first;
      // Combine and remove duplicates
      final all = {...specific, ...globals}.toList();
      return all;
    });
  }

  Stream<List<Announcement>> watchAllAnnouncements() => (select(announcements)..where((a) => a.isActive.equals(true))..orderBy([(a) => OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)])).watch();
  
  Stream<CompanyInfoData> watchCompanyInfo() => select(companyInfo).watchSingle();
  
  Stream<List<Review>> watchProductReviews(int productId) => (select(reviews)..where((r) => r.productId.equals(productId))).watch();

  Future<bool> isAdmin(String userId) async {
    final admin = await (select(admins)..where((a) => a.id.equals(userId))).getSingleOrNull();
    return admin != null;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pizza_app.db'));
    return NativeDatabase(file, logStatements: true);
  });
}
