// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  ProductDao? _productDaoInstance;

  OrderDao? _orderDaoInstance;

  ReviewDao? _reviewDaoInstance;

  OptionDao? _optionDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `role` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `products` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `description` TEXT, `base_price` REAL, `image` TEXT, `category` TEXT, `discount_percentage` REAL, `has_global_discount` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Order` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `total` REAL NOT NULL, `status` TEXT NOT NULL, `createdAt` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Review` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `note` INTEGER NOT NULL, `comment` TEXT, `createdAt` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `options` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `product_id` INTEGER NOT NULL, `name` TEXT NOT NULL, `price` REAL NOT NULL, `type` TEXT NOT NULL, `is_active` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  OrderDao get orderDao {
    return _orderDaoInstance ??= _$OrderDao(database, changeListener);
  }

  @override
  ReviewDao get reviewDao {
    return _reviewDaoInstance ??= _$ReviewDao(database, changeListener);
  }

  @override
  OptionDao get optionDao {
    return _optionDaoInstance ??= _$OptionDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'password': item.password,
                  'role': item.role
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'password': item.password,
                  'role': item.role
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'password': item.password,
                  'role': item.role
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            email: row['email'] as String,
            password: row['password'] as String,
            role: row['role'] as String));
  }

  @override
  Future<User?> findUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            email: row['email'] as String,
            password: row['password'] as String,
            role: row['role'] as String),
        arguments: [email]);
  }

  @override
  Future<User?> authenticate(
    String email,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM users WHERE email = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            email: row['email'] as String,
            password: row['password'] as String,
            role: row['role'] as String),
        arguments: [email, password]);
  }

  @override
  Future<int?> countUsers() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM users',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'products',
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'base_price': item.basePrice,
                  'image': item.image,
                  'category': item.category,
                  'discount_percentage': item.discountPercentage,
                  'has_global_discount': item.hasGlobalDiscount == null
                      ? null
                      : (item.hasGlobalDiscount! ? 1 : 0)
                }),
        _productUpdateAdapter = UpdateAdapter(
            database,
            'products',
            ['id'],
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'base_price': item.basePrice,
                  'image': item.image,
                  'category': item.category,
                  'discount_percentage': item.discountPercentage,
                  'has_global_discount': item.hasGlobalDiscount == null
                      ? null
                      : (item.hasGlobalDiscount! ? 1 : 0)
                }),
        _productDeletionAdapter = DeletionAdapter(
            database,
            'products',
            ['id'],
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'base_price': item.basePrice,
                  'image': item.image,
                  'category': item.category,
                  'discount_percentage': item.discountPercentage,
                  'has_global_discount': item.hasGlobalDiscount == null
                      ? null
                      : (item.hasGlobalDiscount! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Product> _productInsertionAdapter;

  final UpdateAdapter<Product> _productUpdateAdapter;

  final DeletionAdapter<Product> _productDeletionAdapter;

  @override
  Future<List<Product>> getAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM products',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            basePrice: row['base_price'] as double?,
            image: row['image'] as String?,
            category: row['category'] as String?,
            discountPercentage: row['discount_percentage'] as double?,
            hasGlobalDiscount: row['has_global_discount'] == null
                ? null
                : (row['has_global_discount'] as int) != 0));
  }

  @override
  Future<Product?> getProductById(int id) async {
    return _queryAdapter.query('SELECT * FROM products WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            basePrice: row['base_price'] as double?,
            image: row['image'] as String?,
            category: row['category'] as String?,
            discountPercentage: row['discount_percentage'] as double?,
            hasGlobalDiscount: row['has_global_discount'] == null
                ? null
                : (row['has_global_discount'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> applyGlobalDiscount(
    double percentage,
    bool applyDiscount,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE products      SET discount_percentage = ?1,          has_global_discount = ?2',
        arguments: [percentage, applyDiscount ? 1 : 0]);
  }

  @override
  Future<void> updateProductDiscount(
    int productId,
    double percentage,
    bool applyDiscount,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE products      SET discount_percentage = ?2,          has_global_discount = ?3     WHERE id = ?1',
        arguments: [productId, percentage, applyDiscount ? 1 : 0]);
  }

  @override
  Future<List<Product>> getProductsWithDiscount() async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE has_global_discount = 1',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            basePrice: row['base_price'] as double?,
            image: row['image'] as String?,
            category: row['category'] as String?,
            discountPercentage: row['discount_percentage'] as double?,
            hasGlobalDiscount: row['has_global_discount'] == null
                ? null
                : (row['has_global_discount'] as int) != 0));
  }

  @override
  Future<double?> getAveragePrice() async {
    return _queryAdapter.query(
        'SELECT AVG(       CASE          WHEN has_global_discount = 1 AND discount_percentage IS NOT NULL          THEN price * (1 - discount_percentage / 100)         ELSE price        END     ) as averagePrice FROM products',
        mapper: (Map<String, Object?> row) => row.values.first as double);
  }

  @override
  Future<int?> countProductsWithDiscount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM products WHERE has_global_discount = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertProduct(Product product) async {
    await _productInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _productUpdateAdapter.update(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProduct(Product product) async {
    await _productDeletionAdapter.delete(product);
  }
}

class _$OrderDao extends OrderDao {
  _$OrderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _orderInsertionAdapter = InsertionAdapter(
            database,
            'Order',
            (Order item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'total': item.total,
                  'status': item.status,
                  'createdAt': item.createdAt
                }),
        _orderUpdateAdapter = UpdateAdapter(
            database,
            'Order',
            ['id'],
            (Order item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'total': item.total,
                  'status': item.status,
                  'createdAt': item.createdAt
                }),
        _orderDeletionAdapter = DeletionAdapter(
            database,
            'Order',
            ['id'],
            (Order item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'total': item.total,
                  'status': item.status,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Order> _orderInsertionAdapter;

  final UpdateAdapter<Order> _orderUpdateAdapter;

  final DeletionAdapter<Order> _orderDeletionAdapter;

  @override
  Future<List<Order>> getAllOrders() async {
    return _queryAdapter.queryList('SELECT * FROM order',
        mapper: (Map<String, Object?> row) => Order(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            total: row['total'] as double,
            status: row['status'] as String,
            createdAt: row['createdAt'] as String));
  }

  @override
  Future<List<Order>> findOrdersByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM order WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Order(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            total: row['total'] as double,
            status: row['status'] as String,
            createdAt: row['createdAt'] as String),
        arguments: [userId]);
  }

  @override
  Future<void> insertOrder(Order order) async {
    await _orderInsertionAdapter.insert(order, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateOrder(Order order) async {
    await _orderUpdateAdapter.update(order, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOrder(Order order) async {
    await _orderDeletionAdapter.delete(order);
  }
}

class _$ReviewDao extends ReviewDao {
  _$ReviewDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reviewInsertionAdapter = InsertionAdapter(
            database,
            'Review',
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'note': item.note,
                  'comment': item.comment,
                  'createdAt': item.createdAt
                }),
        _reviewUpdateAdapter = UpdateAdapter(
            database,
            'Review',
            ['id'],
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'note': item.note,
                  'comment': item.comment,
                  'createdAt': item.createdAt
                }),
        _reviewDeletionAdapter = DeletionAdapter(
            database,
            'Review',
            ['id'],
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'note': item.note,
                  'comment': item.comment,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Review> _reviewInsertionAdapter;

  final UpdateAdapter<Review> _reviewUpdateAdapter;

  final DeletionAdapter<Review> _reviewDeletionAdapter;

  @override
  Future<List<Review>> getAllReviews() async {
    return _queryAdapter.queryList('SELECT * FROM review',
        mapper: (Map<String, Object?> row) => Review(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            note: row['note'] as int,
            comment: row['comment'] as String?,
            createdAt: row['createdAt'] as String));
  }

  @override
  Future<List<Review>> findReviewsByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM review WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Review(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            note: row['note'] as int,
            comment: row['comment'] as String?,
            createdAt: row['createdAt'] as String),
        arguments: [userId]);
  }

  @override
  Future<void> insertReview(Review review) async {
    await _reviewInsertionAdapter.insert(review, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateReview(Review review) async {
    await _reviewUpdateAdapter.update(review, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReview(Review review) async {
    await _reviewDeletionAdapter.delete(review);
  }
}

class _$OptionDao extends OptionDao {
  _$OptionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _optionInsertionAdapter = InsertionAdapter(
            database,
            'options',
            (Option item) => <String, Object?>{
                  'id': item.id,
                  'product_id': item.productId,
                  'name': item.name,
                  'price': item.price,
                  'type': item.type,
                  'is_active': item.isActive ? 1 : 0
                }),
        _optionUpdateAdapter = UpdateAdapter(
            database,
            'options',
            ['id'],
            (Option item) => <String, Object?>{
                  'id': item.id,
                  'product_id': item.productId,
                  'name': item.name,
                  'price': item.price,
                  'type': item.type,
                  'is_active': item.isActive ? 1 : 0
                }),
        _optionDeletionAdapter = DeletionAdapter(
            database,
            'options',
            ['id'],
            (Option item) => <String, Object?>{
                  'id': item.id,
                  'product_id': item.productId,
                  'name': item.name,
                  'price': item.price,
                  'type': item.type,
                  'is_active': item.isActive ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Option> _optionInsertionAdapter;

  final UpdateAdapter<Option> _optionUpdateAdapter;

  final DeletionAdapter<Option> _optionDeletionAdapter;

  @override
  Future<List<Option>> getOptionsForProduct(int productId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM options WHERE product_id = ?1 AND is_active = 1',
        mapper: (Map<String, Object?> row) => Option(
            id: row['id'] as int?,
            productId: row['product_id'] as int,
            name: row['name'] as String,
            price: row['price'] as double,
            type: row['type'] as String,
            isActive: (row['is_active'] as int) != 0),
        arguments: [productId]);
  }

  @override
  Future<List<Option>> getAllActiveOptions() async {
    return _queryAdapter.queryList('SELECT * FROM options WHERE is_active = 1',
        mapper: (Map<String, Object?> row) => Option(
            id: row['id'] as int?,
            productId: row['product_id'] as int,
            name: row['name'] as String,
            price: row['price'] as double,
            type: row['type'] as String,
            isActive: (row['is_active'] as int) != 0));
  }

  @override
  Future<void> deleteOptionsForProduct(int productId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM options WHERE product_id = ?1',
        arguments: [productId]);
  }

  @override
  Future<int?> countOptionsForProduct(int productId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM options WHERE product_id = ?1 AND is_active = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [productId]);
  }

  @override
  Future<void> insertOption(Option option) async {
    await _optionInsertionAdapter.insert(option, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateOption(Option option) async {
    await _optionUpdateAdapter.update(option, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOption(Option option) async {
    await _optionDeletionAdapter.delete(option);
  }
}
