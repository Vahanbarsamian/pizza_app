// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _basePriceMeta =
      const VerificationMeta('basePrice');
  @override
  late final GeneratedColumn<double> basePrice = GeneratedColumn<double>(
      'base_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>('discount_percentage', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _hasGlobalDiscountMeta =
      const VerificationMeta('hasGlobalDiscount');
  @override
  late final GeneratedColumn<bool> hasGlobalDiscount = GeneratedColumn<bool>(
      'has_global_discount', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_global_discount" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        basePrice,
        image,
        category,
        discountPercentage,
        hasGlobalDiscount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('base_price')) {
      context.handle(_basePriceMeta,
          basePrice.isAcceptableOrUnknown(data['base_price']!, _basePriceMeta));
    } else if (isInserting) {
      context.missing(_basePriceMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
          _discountPercentageMeta,
          discountPercentage.isAcceptableOrUnknown(
              data['discount_percentage']!, _discountPercentageMeta));
    }
    if (data.containsKey('has_global_discount')) {
      context.handle(
          _hasGlobalDiscountMeta,
          hasGlobalDiscount.isAcceptableOrUnknown(
              data['has_global_discount']!, _hasGlobalDiscountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      basePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_price'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      discountPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_percentage']),
      hasGlobalDiscount: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_global_discount'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? description;
  final double basePrice;
  final String? image;
  final String? category;
  final double? discountPercentage;
  final bool hasGlobalDiscount;
  const Product(
      {required this.id,
      required this.name,
      this.description,
      required this.basePrice,
      this.image,
      this.category,
      this.discountPercentage,
      required this.hasGlobalDiscount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['base_price'] = Variable<double>(basePrice);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || discountPercentage != null) {
      map['discount_percentage'] = Variable<double>(discountPercentage);
    }
    map['has_global_discount'] = Variable<bool>(hasGlobalDiscount);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      basePrice: Value(basePrice),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      discountPercentage: discountPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercentage),
      hasGlobalDiscount: Value(hasGlobalDiscount),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      basePrice: serializer.fromJson<double>(json['basePrice']),
      image: serializer.fromJson<String?>(json['image']),
      category: serializer.fromJson<String?>(json['category']),
      discountPercentage:
          serializer.fromJson<double?>(json['discountPercentage']),
      hasGlobalDiscount: serializer.fromJson<bool>(json['hasGlobalDiscount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'basePrice': serializer.toJson<double>(basePrice),
      'image': serializer.toJson<String?>(image),
      'category': serializer.toJson<String?>(category),
      'discountPercentage': serializer.toJson<double?>(discountPercentage),
      'hasGlobalDiscount': serializer.toJson<bool>(hasGlobalDiscount),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          double? basePrice,
          Value<String?> image = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<double?> discountPercentage = const Value.absent(),
          bool? hasGlobalDiscount}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        basePrice: basePrice ?? this.basePrice,
        image: image.present ? image.value : this.image,
        category: category.present ? category.value : this.category,
        discountPercentage: discountPercentage.present
            ? discountPercentage.value
            : this.discountPercentage,
        hasGlobalDiscount: hasGlobalDiscount ?? this.hasGlobalDiscount,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      basePrice: data.basePrice.present ? data.basePrice.value : this.basePrice,
      image: data.image.present ? data.image.value : this.image,
      category: data.category.present ? data.category.value : this.category,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      hasGlobalDiscount: data.hasGlobalDiscount.present
          ? data.hasGlobalDiscount.value
          : this.hasGlobalDiscount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('basePrice: $basePrice, ')
          ..write('image: $image, ')
          ..write('category: $category, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('hasGlobalDiscount: $hasGlobalDiscount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, basePrice, image,
      category, discountPercentage, hasGlobalDiscount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.basePrice == this.basePrice &&
          other.image == this.image &&
          other.category == this.category &&
          other.discountPercentage == this.discountPercentage &&
          other.hasGlobalDiscount == this.hasGlobalDiscount);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> basePrice;
  final Value<String?> image;
  final Value<String?> category;
  final Value<double?> discountPercentage;
  final Value<bool> hasGlobalDiscount;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.image = const Value.absent(),
    this.category = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.hasGlobalDiscount = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required double basePrice,
    this.image = const Value.absent(),
    this.category = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.hasGlobalDiscount = const Value.absent(),
  })  : name = Value(name),
        basePrice = Value(basePrice);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? basePrice,
    Expression<String>? image,
    Expression<String>? category,
    Expression<double>? discountPercentage,
    Expression<bool>? hasGlobalDiscount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (basePrice != null) 'base_price': basePrice,
      if (image != null) 'image': image,
      if (category != null) 'category': category,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (hasGlobalDiscount != null) 'has_global_discount': hasGlobalDiscount,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<double>? basePrice,
      Value<String?>? image,
      Value<String?>? category,
      Value<double?>? discountPercentage,
      Value<bool>? hasGlobalDiscount}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      image: image ?? this.image,
      category: category ?? this.category,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      hasGlobalDiscount: hasGlobalDiscount ?? this.hasGlobalDiscount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (basePrice.present) {
      map['base_price'] = Variable<double>(basePrice.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (hasGlobalDiscount.present) {
      map['has_global_discount'] = Variable<bool>(hasGlobalDiscount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('basePrice: $basePrice, ')
          ..write('image: $image, ')
          ..write('category: $category, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('hasGlobalDiscount: $hasGlobalDiscount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [products];
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required double basePrice,
  Value<String?> image,
  Value<String?> category,
  Value<double?> discountPercentage,
  Value<bool> hasGlobalDiscount,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<double> basePrice,
  Value<String?> image,
  Value<String?> category,
  Value<double?> discountPercentage,
  Value<bool> hasGlobalDiscount,
});

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get basePrice => $composableBuilder(
      column: $table.basePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasGlobalDiscount => $composableBuilder(
      column: $table.hasGlobalDiscount,
      builder: (column) => ColumnFilters(column));
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get basePrice => $composableBuilder(
      column: $table.basePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasGlobalDiscount => $composableBuilder(
      column: $table.hasGlobalDiscount,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get basePrice =>
      $composableBuilder(column: $table.basePrice, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage, builder: (column) => column);

  GeneratedColumn<bool> get hasGlobalDiscount => $composableBuilder(
      column: $table.hasGlobalDiscount, builder: (column) => column);
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> basePrice = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<double?> discountPercentage = const Value.absent(),
            Value<bool> hasGlobalDiscount = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            description: description,
            basePrice: basePrice,
            image: image,
            category: category,
            discountPercentage: discountPercentage,
            hasGlobalDiscount: hasGlobalDiscount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required double basePrice,
            Value<String?> image = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<double?> discountPercentage = const Value.absent(),
            Value<bool> hasGlobalDiscount = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            description: description,
            basePrice: basePrice,
            image: image,
            category: category,
            discountPercentage: discountPercentage,
            hasGlobalDiscount: hasGlobalDiscount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
}
