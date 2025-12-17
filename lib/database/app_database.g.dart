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
      type: DriftSqlType.int, requiredDuringInsert: false);
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
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>('discount_percentage', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _maxSupplementsMeta =
      const VerificationMeta('maxSupplements');
  @override
  late final GeneratedColumn<int> maxSupplements = GeneratedColumn<int>(
      'max_supplements', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDrinkMeta =
      const VerificationMeta('isDrink');
  @override
  late final GeneratedColumn<bool> isDrink = GeneratedColumn<bool>(
      'is_drink', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_drink" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        basePrice,
        image,
        category,
        hasGlobalDiscount,
        discountPercentage,
        maxSupplements,
        isActive,
        isDrink,
        createdAt
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
    if (data.containsKey('has_global_discount')) {
      context.handle(
          _hasGlobalDiscountMeta,
          hasGlobalDiscount.isAcceptableOrUnknown(
              data['has_global_discount']!, _hasGlobalDiscountMeta));
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
          _discountPercentageMeta,
          discountPercentage.isAcceptableOrUnknown(
              data['discount_percentage']!, _discountPercentageMeta));
    }
    if (data.containsKey('max_supplements')) {
      context.handle(
          _maxSupplementsMeta,
          maxSupplements.isAcceptableOrUnknown(
              data['max_supplements']!, _maxSupplementsMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_drink')) {
      context.handle(_isDrinkMeta,
          isDrink.isAcceptableOrUnknown(data['is_drink']!, _isDrinkMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
      hasGlobalDiscount: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_global_discount'])!,
      discountPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_percentage'])!,
      maxSupplements: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_supplements']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isDrink: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_drink'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
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
  final bool hasGlobalDiscount;
  final double discountPercentage;
  final int? maxSupplements;
  final bool isActive;
  final bool isDrink;
  final DateTime createdAt;
  const Product(
      {required this.id,
      required this.name,
      this.description,
      required this.basePrice,
      this.image,
      this.category,
      required this.hasGlobalDiscount,
      required this.discountPercentage,
      this.maxSupplements,
      required this.isActive,
      required this.isDrink,
      required this.createdAt});
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
    map['has_global_discount'] = Variable<bool>(hasGlobalDiscount);
    map['discount_percentage'] = Variable<double>(discountPercentage);
    if (!nullToAbsent || maxSupplements != null) {
      map['max_supplements'] = Variable<int>(maxSupplements);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_drink'] = Variable<bool>(isDrink);
    map['created_at'] = Variable<DateTime>(createdAt);
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
      hasGlobalDiscount: Value(hasGlobalDiscount),
      discountPercentage: Value(discountPercentage),
      maxSupplements: maxSupplements == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSupplements),
      isActive: Value(isActive),
      isDrink: Value(isDrink),
      createdAt: Value(createdAt),
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
      hasGlobalDiscount: serializer.fromJson<bool>(json['hasGlobalDiscount']),
      discountPercentage:
          serializer.fromJson<double>(json['discountPercentage']),
      maxSupplements: serializer.fromJson<int?>(json['maxSupplements']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDrink: serializer.fromJson<bool>(json['isDrink']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
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
      'hasGlobalDiscount': serializer.toJson<bool>(hasGlobalDiscount),
      'discountPercentage': serializer.toJson<double>(discountPercentage),
      'maxSupplements': serializer.toJson<int?>(maxSupplements),
      'isActive': serializer.toJson<bool>(isActive),
      'isDrink': serializer.toJson<bool>(isDrink),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          double? basePrice,
          Value<String?> image = const Value.absent(),
          Value<String?> category = const Value.absent(),
          bool? hasGlobalDiscount,
          double? discountPercentage,
          Value<int?> maxSupplements = const Value.absent(),
          bool? isActive,
          bool? isDrink,
          DateTime? createdAt}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        basePrice: basePrice ?? this.basePrice,
        image: image.present ? image.value : this.image,
        category: category.present ? category.value : this.category,
        hasGlobalDiscount: hasGlobalDiscount ?? this.hasGlobalDiscount,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        maxSupplements:
            maxSupplements.present ? maxSupplements.value : this.maxSupplements,
        isActive: isActive ?? this.isActive,
        isDrink: isDrink ?? this.isDrink,
        createdAt: createdAt ?? this.createdAt,
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
      hasGlobalDiscount: data.hasGlobalDiscount.present
          ? data.hasGlobalDiscount.value
          : this.hasGlobalDiscount,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      maxSupplements: data.maxSupplements.present
          ? data.maxSupplements.value
          : this.maxSupplements,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDrink: data.isDrink.present ? data.isDrink.value : this.isDrink,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
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
          ..write('hasGlobalDiscount: $hasGlobalDiscount, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('maxSupplements: $maxSupplements, ')
          ..write('isActive: $isActive, ')
          ..write('isDrink: $isDrink, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      basePrice,
      image,
      category,
      hasGlobalDiscount,
      discountPercentage,
      maxSupplements,
      isActive,
      isDrink,
      createdAt);
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
          other.hasGlobalDiscount == this.hasGlobalDiscount &&
          other.discountPercentage == this.discountPercentage &&
          other.maxSupplements == this.maxSupplements &&
          other.isActive == this.isActive &&
          other.isDrink == this.isDrink &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> basePrice;
  final Value<String?> image;
  final Value<String?> category;
  final Value<bool> hasGlobalDiscount;
  final Value<double> discountPercentage;
  final Value<int?> maxSupplements;
  final Value<bool> isActive;
  final Value<bool> isDrink;
  final Value<DateTime> createdAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.image = const Value.absent(),
    this.category = const Value.absent(),
    this.hasGlobalDiscount = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.maxSupplements = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDrink = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required double basePrice,
    this.image = const Value.absent(),
    this.category = const Value.absent(),
    this.hasGlobalDiscount = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.maxSupplements = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDrink = const Value.absent(),
    required DateTime createdAt,
  })  : name = Value(name),
        basePrice = Value(basePrice),
        createdAt = Value(createdAt);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? basePrice,
    Expression<String>? image,
    Expression<String>? category,
    Expression<bool>? hasGlobalDiscount,
    Expression<double>? discountPercentage,
    Expression<int>? maxSupplements,
    Expression<bool>? isActive,
    Expression<bool>? isDrink,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (basePrice != null) 'base_price': basePrice,
      if (image != null) 'image': image,
      if (category != null) 'category': category,
      if (hasGlobalDiscount != null) 'has_global_discount': hasGlobalDiscount,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (maxSupplements != null) 'max_supplements': maxSupplements,
      if (isActive != null) 'is_active': isActive,
      if (isDrink != null) 'is_drink': isDrink,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<double>? basePrice,
      Value<String?>? image,
      Value<String?>? category,
      Value<bool>? hasGlobalDiscount,
      Value<double>? discountPercentage,
      Value<int?>? maxSupplements,
      Value<bool>? isActive,
      Value<bool>? isDrink,
      Value<DateTime>? createdAt}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      image: image ?? this.image,
      category: category ?? this.category,
      hasGlobalDiscount: hasGlobalDiscount ?? this.hasGlobalDiscount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      maxSupplements: maxSupplements ?? this.maxSupplements,
      isActive: isActive ?? this.isActive,
      isDrink: isDrink ?? this.isDrink,
      createdAt: createdAt ?? this.createdAt,
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
    if (hasGlobalDiscount.present) {
      map['has_global_discount'] = Variable<bool>(hasGlobalDiscount.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (maxSupplements.present) {
      map['max_supplements'] = Variable<int>(maxSupplements.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDrink.present) {
      map['is_drink'] = Variable<bool>(isDrink.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
          ..write('hasGlobalDiscount: $hasGlobalDiscount, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('maxSupplements: $maxSupplements, ')
          ..write('isActive: $isActive, ')
          ..write('isDrink: $isDrink, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _postalCodeMeta =
      const VerificationMeta('postalCode');
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
      'postal_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, postalCode, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('postal_code')) {
      context.handle(
          _postalCodeMeta,
          postalCode.isAcceptableOrUnknown(
              data['postal_code']!, _postalCodeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      postalCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_code']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String? name;
  final String email;
  final String? postalCode;
  final DateTime createdAt;
  const User(
      {required this.id,
      this.name,
      required this.email,
      this.postalCode,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || postalCode != null) {
      map['postal_code'] = Variable<String>(postalCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email: Value(email),
      postalCode: postalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCode),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      postalCode: serializer.fromJson<String?>(json['postalCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String>(email),
      'postalCode': serializer.toJson<String?>(postalCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          String? email,
          Value<String?> postalCode = const Value.absent(),
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        email: email ?? this.email,
        postalCode: postalCode.present ? postalCode.value : this.postalCode,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      postalCode:
          data.postalCode.present ? data.postalCode.value : this.postalCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('postalCode: $postalCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, postalCode, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.postalCode == this.postalCode &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String> email;
  final Value<String?> postalCode;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required String email,
    this.postalCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? postalCode,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (postalCode != null) 'postal_code': postalCode,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<String>? email,
      Value<String?>? postalCode,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      postalCode: postalCode ?? this.postalCode,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('postalCode: $postalCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceNameMeta =
      const VerificationMeta('referenceName');
  @override
  late final GeneratedColumn<String> referenceName = GeneratedColumn<String>(
      'reference_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pickupTimeMeta =
      const VerificationMeta('pickupTime');
  @override
  late final GeneratedColumn<String> pickupTime = GeneratedColumn<String>(
      'pickup_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_archived" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        referenceName,
        pickupTime,
        paymentMethod,
        total,
        createdAt,
        updatedAt,
        isArchived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('reference_name')) {
      context.handle(
          _referenceNameMeta,
          referenceName.isAcceptableOrUnknown(
              data['reference_name']!, _referenceNameMeta));
    }
    if (data.containsKey('pickup_time')) {
      context.handle(
          _pickupTimeMeta,
          pickupTime.isAcceptableOrUnknown(
              data['pickup_time']!, _pickupTimeMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      referenceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_name']),
      pickupTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pickup_time']),
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived']),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final String userId;
  final String? referenceName;
  final String? pickupTime;
  final String? paymentMethod;
  final double total;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool? isArchived;
  const Order(
      {required this.id,
      required this.userId,
      this.referenceName,
      this.pickupTime,
      this.paymentMethod,
      required this.total,
      required this.createdAt,
      this.updatedAt,
      this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || referenceName != null) {
      map['reference_name'] = Variable<String>(referenceName);
    }
    if (!nullToAbsent || pickupTime != null) {
      map['pickup_time'] = Variable<String>(pickupTime);
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    map['total'] = Variable<double>(total);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || isArchived != null) {
      map['is_archived'] = Variable<bool>(isArchived);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      userId: Value(userId),
      referenceName: referenceName == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceName),
      pickupTime: pickupTime == null && nullToAbsent
          ? const Value.absent()
          : Value(pickupTime),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      total: Value(total),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isArchived: isArchived == null && nullToAbsent
          ? const Value.absent()
          : Value(isArchived),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      referenceName: serializer.fromJson<String?>(json['referenceName']),
      pickupTime: serializer.fromJson<String?>(json['pickupTime']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      total: serializer.fromJson<double>(json['total']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isArchived: serializer.fromJson<bool?>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'referenceName': serializer.toJson<String?>(referenceName),
      'pickupTime': serializer.toJson<String?>(pickupTime),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'total': serializer.toJson<double>(total),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isArchived': serializer.toJson<bool?>(isArchived),
    };
  }

  Order copyWith(
          {int? id,
          String? userId,
          Value<String?> referenceName = const Value.absent(),
          Value<String?> pickupTime = const Value.absent(),
          Value<String?> paymentMethod = const Value.absent(),
          double? total,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<bool?> isArchived = const Value.absent()}) =>
      Order(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        referenceName:
            referenceName.present ? referenceName.value : this.referenceName,
        pickupTime: pickupTime.present ? pickupTime.value : this.pickupTime,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        total: total ?? this.total,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isArchived: isArchived.present ? isArchived.value : this.isArchived,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      referenceName: data.referenceName.present
          ? data.referenceName.value
          : this.referenceName,
      pickupTime:
          data.pickupTime.present ? data.pickupTime.value : this.pickupTime,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      total: data.total.present ? data.total.value : this.total,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('referenceName: $referenceName, ')
          ..write('pickupTime: $pickupTime, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, referenceName, pickupTime,
      paymentMethod, total, createdAt, updatedAt, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.referenceName == this.referenceName &&
          other.pickupTime == this.pickupTime &&
          other.paymentMethod == this.paymentMethod &&
          other.total == this.total &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String?> referenceName;
  final Value<String?> pickupTime;
  final Value<String?> paymentMethod;
  final Value<double> total;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool?> isArchived;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.referenceName = const Value.absent(),
    this.pickupTime = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.total = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.referenceName = const Value.absent(),
    this.pickupTime = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    required double total,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
  })  : userId = Value(userId),
        total = Value(total),
        createdAt = Value(createdAt);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? referenceName,
    Expression<String>? pickupTime,
    Expression<String>? paymentMethod,
    Expression<double>? total,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (referenceName != null) 'reference_name': referenceName,
      if (pickupTime != null) 'pickup_time': pickupTime,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (total != null) 'total': total,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  OrdersCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String?>? referenceName,
      Value<String?>? pickupTime,
      Value<String?>? paymentMethod,
      Value<double>? total,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool?>? isArchived}) {
    return OrdersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      referenceName: referenceName ?? this.referenceName,
      pickupTime: pickupTime ?? this.pickupTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (referenceName.present) {
      map['reference_name'] = Variable<String>(referenceName.value);
    }
    if (pickupTime.present) {
      map['pickup_time'] = Variable<String>(pickupTime.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('referenceName: $referenceName, ')
          ..write('pickupTime: $pickupTime, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionsDescriptionMeta =
      const VerificationMeta('optionsDescription');
  @override
  late final GeneratedColumn<String> optionsDescription =
      GeneratedColumn<String>('options_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        productId,
        quantity,
        unitPrice,
        productName,
        optionsDescription
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('options_description')) {
      context.handle(
          _optionsDescriptionMeta,
          optionsDescription.isAcceptableOrUnknown(
              data['options_description']!, _optionsDescriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      optionsDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}options_description']),
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final String productName;
  final String? optionsDescription;
  const OrderItem(
      {required this.id,
      required this.orderId,
      required this.productId,
      required this.quantity,
      required this.unitPrice,
      required this.productName,
      this.optionsDescription});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || optionsDescription != null) {
      map['options_description'] = Variable<String>(optionsDescription);
    }
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      productName: Value(productName),
      optionsDescription: optionsDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(optionsDescription),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      productName: serializer.fromJson<String>(json['productName']),
      optionsDescription:
          serializer.fromJson<String?>(json['optionsDescription']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'productName': serializer.toJson<String>(productName),
      'optionsDescription': serializer.toJson<String?>(optionsDescription),
    };
  }

  OrderItem copyWith(
          {int? id,
          int? orderId,
          int? productId,
          int? quantity,
          double? unitPrice,
          String? productName,
          Value<String?> optionsDescription = const Value.absent()}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        productName: productName ?? this.productName,
        optionsDescription: optionsDescription.present
            ? optionsDescription.value
            : this.optionsDescription,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      optionsDescription: data.optionsDescription.present
          ? data.optionsDescription.value
          : this.optionsDescription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('productName: $productName, ')
          ..write('optionsDescription: $optionsDescription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, productId, quantity, unitPrice,
      productName, optionsDescription);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.productName == this.productName &&
          other.optionsDescription == this.optionsDescription);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> productId;
  final Value<int> quantity;
  final Value<double> unitPrice;
  final Value<String> productName;
  final Value<String?> optionsDescription;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.productName = const Value.absent(),
    this.optionsDescription = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int productId,
    required int quantity,
    required double unitPrice,
    required String productName,
    this.optionsDescription = const Value.absent(),
  })  : orderId = Value(orderId),
        productId = Value(productId),
        quantity = Value(quantity),
        unitPrice = Value(unitPrice),
        productName = Value(productName);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? productId,
    Expression<int>? quantity,
    Expression<double>? unitPrice,
    Expression<String>? productName,
    Expression<String>? optionsDescription,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (productName != null) 'product_name': productName,
      if (optionsDescription != null) 'options_description': optionsDescription,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? productId,
      Value<int>? quantity,
      Value<double>? unitPrice,
      Value<String>? productName,
      Value<String?>? optionsDescription}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      productName: productName ?? this.productName,
      optionsDescription: optionsDescription ?? this.optionsDescription,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (optionsDescription.present) {
      map['options_description'] = Variable<String>(optionsDescription.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('productName: $productName, ')
          ..write('optionsDescription: $optionsDescription')
          ..write(')'))
        .toString();
  }
}

class $ReviewsTable extends Reviews with TableInfo<$ReviewsTable, Review> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orderId, userId, rating, comment, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reviews';
  @override
  VerificationContext validateIntegrity(Insertable<Review> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Review map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Review(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReviewsTable createAlias(String alias) {
    return $ReviewsTable(attachedDatabase, alias);
  }
}

class Review extends DataClass implements Insertable<Review> {
  final int id;
  final int orderId;
  final String userId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  const Review(
      {required this.id,
      required this.orderId,
      required this.userId,
      required this.rating,
      this.comment,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['user_id'] = Variable<String>(userId);
    map['rating'] = Variable<int>(rating);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReviewsCompanion toCompanion(bool nullToAbsent) {
    return ReviewsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      userId: Value(userId),
      rating: Value(rating),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAt: Value(createdAt),
    );
  }

  factory Review.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Review(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      userId: serializer.fromJson<String>(json['userId']),
      rating: serializer.fromJson<int>(json['rating']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'userId': serializer.toJson<String>(userId),
      'rating': serializer.toJson<int>(rating),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Review copyWith(
          {int? id,
          int? orderId,
          String? userId,
          int? rating,
          Value<String?> comment = const Value.absent(),
          DateTime? createdAt}) =>
      Review(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        userId: userId ?? this.userId,
        rating: rating ?? this.rating,
        comment: comment.present ? comment.value : this.comment,
        createdAt: createdAt ?? this.createdAt,
      );
  Review copyWithCompanion(ReviewsCompanion data) {
    return Review(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      userId: data.userId.present ? data.userId.value : this.userId,
      rating: data.rating.present ? data.rating.value : this.rating,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Review(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('userId: $userId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, userId, rating, comment, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Review &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.userId == this.userId &&
          other.rating == this.rating &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt);
}

class ReviewsCompanion extends UpdateCompanion<Review> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<String> userId;
  final Value<int> rating;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  const ReviewsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rating = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReviewsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required String userId,
    required int rating,
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : orderId = Value(orderId),
        userId = Value(userId),
        rating = Value(rating);
  static Insertable<Review> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<String>? userId,
    Expression<int>? rating,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (userId != null) 'user_id': userId,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReviewsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<String>? userId,
      Value<int>? rating,
      Value<String?>? comment,
      Value<DateTime>? createdAt}) {
    return ReviewsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('userId: $userId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isGlobalMeta =
      const VerificationMeta('isGlobal');
  @override
  late final GeneratedColumn<bool> isGlobal = GeneratedColumn<bool>(
      'is_global', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_global" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, price, category, isGlobal, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<Ingredient> instance,
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
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_global')) {
      context.handle(_isGlobalMeta,
          isGlobal.isAcceptableOrUnknown(data['is_global']!, _isGlobalMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      isGlobal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_global'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final String name;
  final double price;
  final String? category;
  final bool isGlobal;
  final DateTime createdAt;
  const Ingredient(
      {required this.id,
      required this.name,
      required this.price,
      this.category,
      required this.isGlobal,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_global'] = Variable<bool>(isGlobal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isGlobal: Value(isGlobal),
      createdAt: Value(createdAt),
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      category: serializer.fromJson<String?>(json['category']),
      isGlobal: serializer.fromJson<bool>(json['isGlobal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'category': serializer.toJson<String?>(category),
      'isGlobal': serializer.toJson<bool>(isGlobal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Ingredient copyWith(
          {int? id,
          String? name,
          double? price,
          Value<String?> category = const Value.absent(),
          bool? isGlobal,
          DateTime? createdAt}) =>
      Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        category: category.present ? category.value : this.category,
        isGlobal: isGlobal ?? this.isGlobal,
        createdAt: createdAt ?? this.createdAt,
      );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      isGlobal: data.isGlobal.present ? data.isGlobal.value : this.isGlobal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, price, category, isGlobal, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.category == this.category &&
          other.isGlobal == this.isGlobal &&
          other.createdAt == this.createdAt);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String?> category;
  final Value<bool> isGlobal;
  final Value<DateTime> createdAt;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.isGlobal = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double price,
    this.category = const Value.absent(),
    this.isGlobal = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        price = Value(price);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? category,
    Expression<bool>? isGlobal,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (isGlobal != null) 'is_global': isGlobal,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? price,
      Value<String?>? category,
      Value<bool>? isGlobal,
      Value<DateTime>? createdAt}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      isGlobal: isGlobal ?? this.isGlobal,
      createdAt: createdAt ?? this.createdAt,
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
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isGlobal.present) {
      map['is_global'] = Variable<bool>(isGlobal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AdminsTable extends Admins with TableInfo<$AdminsTable, Admin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdminsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('admin'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, email, role, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'admins';
  @override
  VerificationContext validateIntegrity(Insertable<Admin> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Admin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Admin(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AdminsTable createAlias(String alias) {
    return $AdminsTable(attachedDatabase, alias);
  }
}

class Admin extends DataClass implements Insertable<Admin> {
  final String id;
  final String email;
  final String role;
  final DateTime createdAt;
  const Admin(
      {required this.id,
      required this.email,
      required this.role,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AdminsCompanion toCompanion(bool nullToAbsent) {
    return AdminsCompanion(
      id: Value(id),
      email: Value(email),
      role: Value(role),
      createdAt: Value(createdAt),
    );
  }

  factory Admin.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Admin(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Admin copyWith(
          {String? id, String? email, String? role, DateTime? createdAt}) =>
      Admin(
        id: id ?? this.id,
        email: email ?? this.email,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
      );
  Admin copyWithCompanion(AdminsCompanion data) {
    return Admin(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Admin(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Admin &&
          other.id == this.id &&
          other.email == this.email &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class AdminsCompanion extends UpdateCompanion<Admin> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AdminsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdminsCompanion.insert({
    required String id,
    required String email,
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email);
  static Insertable<Admin> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdminsCompanion copyWith(
      {Value<String>? id,
      Value<String>? email,
      Value<String>? role,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AdminsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdminsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnnouncementsTable extends Announcements
    with TableInfo<$AnnouncementsTable, Announcement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnouncementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _announcementTextMeta =
      const VerificationMeta('announcementText');
  @override
  late final GeneratedColumn<String> announcementText = GeneratedColumn<String>(
      'announcement_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conclusionMeta =
      const VerificationMeta('conclusion');
  @override
  late final GeneratedColumn<String> conclusion = GeneratedColumn<String>(
      'conclusion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Annonce'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        announcementText,
        description,
        imageUrl,
        conclusion,
        isActive,
        type,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'announcements';
  @override
  VerificationContext validateIntegrity(Insertable<Announcement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('announcement_text')) {
      context.handle(
          _announcementTextMeta,
          announcementText.isAcceptableOrUnknown(
              data['announcement_text']!, _announcementTextMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('conclusion')) {
      context.handle(
          _conclusionMeta,
          conclusion.isAcceptableOrUnknown(
              data['conclusion']!, _conclusionMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Announcement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Announcement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      announcementText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}announcement_text']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      conclusion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conclusion']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AnnouncementsTable createAlias(String alias) {
    return $AnnouncementsTable(attachedDatabase, alias);
  }
}

class Announcement extends DataClass implements Insertable<Announcement> {
  final int id;
  final String title;
  final String? announcementText;
  final String? description;
  final String? imageUrl;
  final String? conclusion;
  final bool isActive;
  final String type;
  final DateTime createdAt;
  const Announcement(
      {required this.id,
      required this.title,
      this.announcementText,
      this.description,
      this.imageUrl,
      this.conclusion,
      required this.isActive,
      required this.type,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || announcementText != null) {
      map['announcement_text'] = Variable<String>(announcementText);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || conclusion != null) {
      map['conclusion'] = Variable<String>(conclusion);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AnnouncementsCompanion toCompanion(bool nullToAbsent) {
    return AnnouncementsCompanion(
      id: Value(id),
      title: Value(title),
      announcementText: announcementText == null && nullToAbsent
          ? const Value.absent()
          : Value(announcementText),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      conclusion: conclusion == null && nullToAbsent
          ? const Value.absent()
          : Value(conclusion),
      isActive: Value(isActive),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory Announcement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Announcement(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      announcementText: serializer.fromJson<String?>(json['announcementText']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      conclusion: serializer.fromJson<String?>(json['conclusion']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'announcementText': serializer.toJson<String?>(announcementText),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'conclusion': serializer.toJson<String?>(conclusion),
      'isActive': serializer.toJson<bool>(isActive),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Announcement copyWith(
          {int? id,
          String? title,
          Value<String?> announcementText = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          Value<String?> conclusion = const Value.absent(),
          bool? isActive,
          String? type,
          DateTime? createdAt}) =>
      Announcement(
        id: id ?? this.id,
        title: title ?? this.title,
        announcementText: announcementText.present
            ? announcementText.value
            : this.announcementText,
        description: description.present ? description.value : this.description,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        conclusion: conclusion.present ? conclusion.value : this.conclusion,
        isActive: isActive ?? this.isActive,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
      );
  Announcement copyWithCompanion(AnnouncementsCompanion data) {
    return Announcement(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      announcementText: data.announcementText.present
          ? data.announcementText.value
          : this.announcementText,
      description:
          data.description.present ? data.description.value : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      conclusion:
          data.conclusion.present ? data.conclusion.value : this.conclusion,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Announcement(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('announcementText: $announcementText, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('conclusion: $conclusion, ')
          ..write('isActive: $isActive, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, announcementText, description,
      imageUrl, conclusion, isActive, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Announcement &&
          other.id == this.id &&
          other.title == this.title &&
          other.announcementText == this.announcementText &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.conclusion == this.conclusion &&
          other.isActive == this.isActive &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class AnnouncementsCompanion extends UpdateCompanion<Announcement> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> announcementText;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<String?> conclusion;
  final Value<bool> isActive;
  final Value<String> type;
  final Value<DateTime> createdAt;
  const AnnouncementsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.announcementText = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.conclusion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AnnouncementsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.announcementText = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.conclusion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.type = const Value.absent(),
    required DateTime createdAt,
  })  : title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<Announcement> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? announcementText,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<String>? conclusion,
    Expression<bool>? isActive,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (announcementText != null) 'announcement_text': announcementText,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (conclusion != null) 'conclusion': conclusion,
      if (isActive != null) 'is_active': isActive,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AnnouncementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? announcementText,
      Value<String?>? description,
      Value<String?>? imageUrl,
      Value<String?>? conclusion,
      Value<bool>? isActive,
      Value<String>? type,
      Value<DateTime>? createdAt}) {
    return AnnouncementsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      announcementText: announcementText ?? this.announcementText,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      conclusion: conclusion ?? this.conclusion,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (announcementText.present) {
      map['announcement_text'] = Variable<String>(announcementText.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (conclusion.present) {
      map['conclusion'] = Variable<String>(conclusion.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnouncementsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('announcementText: $announcementText, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('conclusion: $conclusion, ')
          ..write('isActive: $isActive, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CompanyInfoTable extends CompanyInfo
    with TableInfo<$CompanyInfoTable, CompanyInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanyInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _presentationMeta =
      const VerificationMeta('presentation');
  @override
  late final GeneratedColumn<String> presentation = GeneratedColumn<String>(
      'presentation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _facebookUrlMeta =
      const VerificationMeta('facebookUrl');
  @override
  late final GeneratedColumn<String> facebookUrl = GeneratedColumn<String>(
      'facebook_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _instagramUrlMeta =
      const VerificationMeta('instagramUrl');
  @override
  late final GeneratedColumn<String> instagramUrl = GeneratedColumn<String>(
      'instagram_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _xUrlMeta = const VerificationMeta('xUrl');
  @override
  late final GeneratedColumn<String> xUrl = GeneratedColumn<String>(
      'x_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whatsappPhoneMeta =
      const VerificationMeta('whatsappPhone');
  @override
  late final GeneratedColumn<String> whatsappPhone = GeneratedColumn<String>(
      'whatsapp_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ordersEnabledMeta =
      const VerificationMeta('ordersEnabled');
  @override
  late final GeneratedColumn<bool> ordersEnabled = GeneratedColumn<bool>(
      'orders_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("orders_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _closureMessageTypeMeta =
      const VerificationMeta('closureMessageType');
  @override
  late final GeneratedColumn<String> closureMessageType =
      GeneratedColumn<String>('closure_message_type', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _closureStartDateMeta =
      const VerificationMeta('closureStartDate');
  @override
  late final GeneratedColumn<DateTime> closureStartDate =
      GeneratedColumn<DateTime>('closure_start_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _closureEndDateMeta =
      const VerificationMeta('closureEndDate');
  @override
  late final GeneratedColumn<DateTime> closureEndDate =
      GeneratedColumn<DateTime>('closure_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _closureCustomMessageMeta =
      const VerificationMeta('closureCustomMessage');
  @override
  late final GeneratedColumn<String> closureCustomMessage =
      GeneratedColumn<String>('closure_custom_message', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tvaRateMeta =
      const VerificationMeta('tvaRate');
  @override
  late final GeneratedColumn<double> tvaRate = GeneratedColumn<double>(
      'tva_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _googleUrlMeta =
      const VerificationMeta('googleUrl');
  @override
  late final GeneratedColumn<String> googleUrl = GeneratedColumn<String>(
      'google_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pagesJaunesUrlMeta =
      const VerificationMeta('pagesJaunesUrl');
  @override
  late final GeneratedColumn<String> pagesJaunesUrl = GeneratedColumn<String>(
      'pagesjaunes_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        presentation,
        address,
        phone,
        email,
        facebookUrl,
        instagramUrl,
        xUrl,
        whatsappPhone,
        latitude,
        longitude,
        ordersEnabled,
        closureMessageType,
        closureStartDate,
        closureEndDate,
        closureCustomMessage,
        logoUrl,
        tvaRate,
        googleUrl,
        pagesJaunesUrl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_info';
  @override
  VerificationContext validateIntegrity(Insertable<CompanyInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('presentation')) {
      context.handle(
          _presentationMeta,
          presentation.isAcceptableOrUnknown(
              data['presentation']!, _presentationMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('facebook_url')) {
      context.handle(
          _facebookUrlMeta,
          facebookUrl.isAcceptableOrUnknown(
              data['facebook_url']!, _facebookUrlMeta));
    }
    if (data.containsKey('instagram_url')) {
      context.handle(
          _instagramUrlMeta,
          instagramUrl.isAcceptableOrUnknown(
              data['instagram_url']!, _instagramUrlMeta));
    }
    if (data.containsKey('x_url')) {
      context.handle(
          _xUrlMeta, xUrl.isAcceptableOrUnknown(data['x_url']!, _xUrlMeta));
    }
    if (data.containsKey('whatsapp_phone')) {
      context.handle(
          _whatsappPhoneMeta,
          whatsappPhone.isAcceptableOrUnknown(
              data['whatsapp_phone']!, _whatsappPhoneMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('orders_enabled')) {
      context.handle(
          _ordersEnabledMeta,
          ordersEnabled.isAcceptableOrUnknown(
              data['orders_enabled']!, _ordersEnabledMeta));
    }
    if (data.containsKey('closure_message_type')) {
      context.handle(
          _closureMessageTypeMeta,
          closureMessageType.isAcceptableOrUnknown(
              data['closure_message_type']!, _closureMessageTypeMeta));
    }
    if (data.containsKey('closure_start_date')) {
      context.handle(
          _closureStartDateMeta,
          closureStartDate.isAcceptableOrUnknown(
              data['closure_start_date']!, _closureStartDateMeta));
    }
    if (data.containsKey('closure_end_date')) {
      context.handle(
          _closureEndDateMeta,
          closureEndDate.isAcceptableOrUnknown(
              data['closure_end_date']!, _closureEndDateMeta));
    }
    if (data.containsKey('closure_custom_message')) {
      context.handle(
          _closureCustomMessageMeta,
          closureCustomMessage.isAcceptableOrUnknown(
              data['closure_custom_message']!, _closureCustomMessageMeta));
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('tva_rate')) {
      context.handle(_tvaRateMeta,
          tvaRate.isAcceptableOrUnknown(data['tva_rate']!, _tvaRateMeta));
    }
    if (data.containsKey('google_url')) {
      context.handle(_googleUrlMeta,
          googleUrl.isAcceptableOrUnknown(data['google_url']!, _googleUrlMeta));
    }
    if (data.containsKey('pagesjaunes_url')) {
      context.handle(
          _pagesJaunesUrlMeta,
          pagesJaunesUrl.isAcceptableOrUnknown(
              data['pagesjaunes_url']!, _pagesJaunesUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompanyInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompanyInfoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      presentation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}presentation']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      facebookUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}facebook_url']),
      instagramUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instagram_url']),
      xUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}x_url']),
      whatsappPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp_phone']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      ordersEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}orders_enabled'])!,
      closureMessageType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}closure_message_type']),
      closureStartDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}closure_start_date']),
      closureEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}closure_end_date']),
      closureCustomMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}closure_custom_message']),
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      tvaRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tva_rate']),
      googleUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}google_url']),
      pagesJaunesUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pagesjaunes_url']),
    );
  }

  @override
  $CompanyInfoTable createAlias(String alias) {
    return $CompanyInfoTable(attachedDatabase, alias);
  }
}

class CompanyInfoData extends DataClass implements Insertable<CompanyInfoData> {
  final int id;
  final String? name;
  final String? presentation;
  final String? address;
  final String? phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? xUrl;
  final String? whatsappPhone;
  final double? latitude;
  final double? longitude;
  final bool ordersEnabled;
  final String? closureMessageType;
  final DateTime? closureStartDate;
  final DateTime? closureEndDate;
  final String? closureCustomMessage;
  final String? logoUrl;
  final double? tvaRate;
  final String? googleUrl;
  final String? pagesJaunesUrl;
  const CompanyInfoData(
      {required this.id,
      this.name,
      this.presentation,
      this.address,
      this.phone,
      this.email,
      this.facebookUrl,
      this.instagramUrl,
      this.xUrl,
      this.whatsappPhone,
      this.latitude,
      this.longitude,
      required this.ordersEnabled,
      this.closureMessageType,
      this.closureStartDate,
      this.closureEndDate,
      this.closureCustomMessage,
      this.logoUrl,
      this.tvaRate,
      this.googleUrl,
      this.pagesJaunesUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || presentation != null) {
      map['presentation'] = Variable<String>(presentation);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || facebookUrl != null) {
      map['facebook_url'] = Variable<String>(facebookUrl);
    }
    if (!nullToAbsent || instagramUrl != null) {
      map['instagram_url'] = Variable<String>(instagramUrl);
    }
    if (!nullToAbsent || xUrl != null) {
      map['x_url'] = Variable<String>(xUrl);
    }
    if (!nullToAbsent || whatsappPhone != null) {
      map['whatsapp_phone'] = Variable<String>(whatsappPhone);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['orders_enabled'] = Variable<bool>(ordersEnabled);
    if (!nullToAbsent || closureMessageType != null) {
      map['closure_message_type'] = Variable<String>(closureMessageType);
    }
    if (!nullToAbsent || closureStartDate != null) {
      map['closure_start_date'] = Variable<DateTime>(closureStartDate);
    }
    if (!nullToAbsent || closureEndDate != null) {
      map['closure_end_date'] = Variable<DateTime>(closureEndDate);
    }
    if (!nullToAbsent || closureCustomMessage != null) {
      map['closure_custom_message'] = Variable<String>(closureCustomMessage);
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || tvaRate != null) {
      map['tva_rate'] = Variable<double>(tvaRate);
    }
    if (!nullToAbsent || googleUrl != null) {
      map['google_url'] = Variable<String>(googleUrl);
    }
    if (!nullToAbsent || pagesJaunesUrl != null) {
      map['pagesjaunes_url'] = Variable<String>(pagesJaunesUrl);
    }
    return map;
  }

  CompanyInfoCompanion toCompanion(bool nullToAbsent) {
    return CompanyInfoCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      presentation: presentation == null && nullToAbsent
          ? const Value.absent()
          : Value(presentation),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      facebookUrl: facebookUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(facebookUrl),
      instagramUrl: instagramUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(instagramUrl),
      xUrl: xUrl == null && nullToAbsent ? const Value.absent() : Value(xUrl),
      whatsappPhone: whatsappPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappPhone),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      ordersEnabled: Value(ordersEnabled),
      closureMessageType: closureMessageType == null && nullToAbsent
          ? const Value.absent()
          : Value(closureMessageType),
      closureStartDate: closureStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(closureStartDate),
      closureEndDate: closureEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(closureEndDate),
      closureCustomMessage: closureCustomMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(closureCustomMessage),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      tvaRate: tvaRate == null && nullToAbsent
          ? const Value.absent()
          : Value(tvaRate),
      googleUrl: googleUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(googleUrl),
      pagesJaunesUrl: pagesJaunesUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(pagesJaunesUrl),
    );
  }

  factory CompanyInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompanyInfoData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      presentation: serializer.fromJson<String?>(json['presentation']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      facebookUrl: serializer.fromJson<String?>(json['facebookUrl']),
      instagramUrl: serializer.fromJson<String?>(json['instagramUrl']),
      xUrl: serializer.fromJson<String?>(json['xUrl']),
      whatsappPhone: serializer.fromJson<String?>(json['whatsappPhone']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      ordersEnabled: serializer.fromJson<bool>(json['ordersEnabled']),
      closureMessageType:
          serializer.fromJson<String?>(json['closureMessageType']),
      closureStartDate:
          serializer.fromJson<DateTime?>(json['closureStartDate']),
      closureEndDate: serializer.fromJson<DateTime?>(json['closureEndDate']),
      closureCustomMessage:
          serializer.fromJson<String?>(json['closureCustomMessage']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      tvaRate: serializer.fromJson<double?>(json['tvaRate']),
      googleUrl: serializer.fromJson<String?>(json['googleUrl']),
      pagesJaunesUrl: serializer.fromJson<String?>(json['pagesJaunesUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'presentation': serializer.toJson<String?>(presentation),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'facebookUrl': serializer.toJson<String?>(facebookUrl),
      'instagramUrl': serializer.toJson<String?>(instagramUrl),
      'xUrl': serializer.toJson<String?>(xUrl),
      'whatsappPhone': serializer.toJson<String?>(whatsappPhone),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'ordersEnabled': serializer.toJson<bool>(ordersEnabled),
      'closureMessageType': serializer.toJson<String?>(closureMessageType),
      'closureStartDate': serializer.toJson<DateTime?>(closureStartDate),
      'closureEndDate': serializer.toJson<DateTime?>(closureEndDate),
      'closureCustomMessage': serializer.toJson<String?>(closureCustomMessage),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'tvaRate': serializer.toJson<double?>(tvaRate),
      'googleUrl': serializer.toJson<String?>(googleUrl),
      'pagesJaunesUrl': serializer.toJson<String?>(pagesJaunesUrl),
    };
  }

  CompanyInfoData copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> presentation = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> facebookUrl = const Value.absent(),
          Value<String?> instagramUrl = const Value.absent(),
          Value<String?> xUrl = const Value.absent(),
          Value<String?> whatsappPhone = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          bool? ordersEnabled,
          Value<String?> closureMessageType = const Value.absent(),
          Value<DateTime?> closureStartDate = const Value.absent(),
          Value<DateTime?> closureEndDate = const Value.absent(),
          Value<String?> closureCustomMessage = const Value.absent(),
          Value<String?> logoUrl = const Value.absent(),
          Value<double?> tvaRate = const Value.absent(),
          Value<String?> googleUrl = const Value.absent(),
          Value<String?> pagesJaunesUrl = const Value.absent()}) =>
      CompanyInfoData(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        presentation:
            presentation.present ? presentation.value : this.presentation,
        address: address.present ? address.value : this.address,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        facebookUrl: facebookUrl.present ? facebookUrl.value : this.facebookUrl,
        instagramUrl:
            instagramUrl.present ? instagramUrl.value : this.instagramUrl,
        xUrl: xUrl.present ? xUrl.value : this.xUrl,
        whatsappPhone:
            whatsappPhone.present ? whatsappPhone.value : this.whatsappPhone,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        ordersEnabled: ordersEnabled ?? this.ordersEnabled,
        closureMessageType: closureMessageType.present
            ? closureMessageType.value
            : this.closureMessageType,
        closureStartDate: closureStartDate.present
            ? closureStartDate.value
            : this.closureStartDate,
        closureEndDate:
            closureEndDate.present ? closureEndDate.value : this.closureEndDate,
        closureCustomMessage: closureCustomMessage.present
            ? closureCustomMessage.value
            : this.closureCustomMessage,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        tvaRate: tvaRate.present ? tvaRate.value : this.tvaRate,
        googleUrl: googleUrl.present ? googleUrl.value : this.googleUrl,
        pagesJaunesUrl:
            pagesJaunesUrl.present ? pagesJaunesUrl.value : this.pagesJaunesUrl,
      );
  CompanyInfoData copyWithCompanion(CompanyInfoCompanion data) {
    return CompanyInfoData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      presentation: data.presentation.present
          ? data.presentation.value
          : this.presentation,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      facebookUrl:
          data.facebookUrl.present ? data.facebookUrl.value : this.facebookUrl,
      instagramUrl: data.instagramUrl.present
          ? data.instagramUrl.value
          : this.instagramUrl,
      xUrl: data.xUrl.present ? data.xUrl.value : this.xUrl,
      whatsappPhone: data.whatsappPhone.present
          ? data.whatsappPhone.value
          : this.whatsappPhone,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      ordersEnabled: data.ordersEnabled.present
          ? data.ordersEnabled.value
          : this.ordersEnabled,
      closureMessageType: data.closureMessageType.present
          ? data.closureMessageType.value
          : this.closureMessageType,
      closureStartDate: data.closureStartDate.present
          ? data.closureStartDate.value
          : this.closureStartDate,
      closureEndDate: data.closureEndDate.present
          ? data.closureEndDate.value
          : this.closureEndDate,
      closureCustomMessage: data.closureCustomMessage.present
          ? data.closureCustomMessage.value
          : this.closureCustomMessage,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      tvaRate: data.tvaRate.present ? data.tvaRate.value : this.tvaRate,
      googleUrl: data.googleUrl.present ? data.googleUrl.value : this.googleUrl,
      pagesJaunesUrl: data.pagesJaunesUrl.present
          ? data.pagesJaunesUrl.value
          : this.pagesJaunesUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompanyInfoData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('presentation: $presentation, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('facebookUrl: $facebookUrl, ')
          ..write('instagramUrl: $instagramUrl, ')
          ..write('xUrl: $xUrl, ')
          ..write('whatsappPhone: $whatsappPhone, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('ordersEnabled: $ordersEnabled, ')
          ..write('closureMessageType: $closureMessageType, ')
          ..write('closureStartDate: $closureStartDate, ')
          ..write('closureEndDate: $closureEndDate, ')
          ..write('closureCustomMessage: $closureCustomMessage, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('tvaRate: $tvaRate, ')
          ..write('googleUrl: $googleUrl, ')
          ..write('pagesJaunesUrl: $pagesJaunesUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        presentation,
        address,
        phone,
        email,
        facebookUrl,
        instagramUrl,
        xUrl,
        whatsappPhone,
        latitude,
        longitude,
        ordersEnabled,
        closureMessageType,
        closureStartDate,
        closureEndDate,
        closureCustomMessage,
        logoUrl,
        tvaRate,
        googleUrl,
        pagesJaunesUrl
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompanyInfoData &&
          other.id == this.id &&
          other.name == this.name &&
          other.presentation == this.presentation &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.facebookUrl == this.facebookUrl &&
          other.instagramUrl == this.instagramUrl &&
          other.xUrl == this.xUrl &&
          other.whatsappPhone == this.whatsappPhone &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.ordersEnabled == this.ordersEnabled &&
          other.closureMessageType == this.closureMessageType &&
          other.closureStartDate == this.closureStartDate &&
          other.closureEndDate == this.closureEndDate &&
          other.closureCustomMessage == this.closureCustomMessage &&
          other.logoUrl == this.logoUrl &&
          other.tvaRate == this.tvaRate &&
          other.googleUrl == this.googleUrl &&
          other.pagesJaunesUrl == this.pagesJaunesUrl);
}

class CompanyInfoCompanion extends UpdateCompanion<CompanyInfoData> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> presentation;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> facebookUrl;
  final Value<String?> instagramUrl;
  final Value<String?> xUrl;
  final Value<String?> whatsappPhone;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> ordersEnabled;
  final Value<String?> closureMessageType;
  final Value<DateTime?> closureStartDate;
  final Value<DateTime?> closureEndDate;
  final Value<String?> closureCustomMessage;
  final Value<String?> logoUrl;
  final Value<double?> tvaRate;
  final Value<String?> googleUrl;
  final Value<String?> pagesJaunesUrl;
  const CompanyInfoCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.presentation = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.facebookUrl = const Value.absent(),
    this.instagramUrl = const Value.absent(),
    this.xUrl = const Value.absent(),
    this.whatsappPhone = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.ordersEnabled = const Value.absent(),
    this.closureMessageType = const Value.absent(),
    this.closureStartDate = const Value.absent(),
    this.closureEndDate = const Value.absent(),
    this.closureCustomMessage = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.tvaRate = const Value.absent(),
    this.googleUrl = const Value.absent(),
    this.pagesJaunesUrl = const Value.absent(),
  });
  CompanyInfoCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.presentation = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.facebookUrl = const Value.absent(),
    this.instagramUrl = const Value.absent(),
    this.xUrl = const Value.absent(),
    this.whatsappPhone = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.ordersEnabled = const Value.absent(),
    this.closureMessageType = const Value.absent(),
    this.closureStartDate = const Value.absent(),
    this.closureEndDate = const Value.absent(),
    this.closureCustomMessage = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.tvaRate = const Value.absent(),
    this.googleUrl = const Value.absent(),
    this.pagesJaunesUrl = const Value.absent(),
  });
  static Insertable<CompanyInfoData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? presentation,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? facebookUrl,
    Expression<String>? instagramUrl,
    Expression<String>? xUrl,
    Expression<String>? whatsappPhone,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? ordersEnabled,
    Expression<String>? closureMessageType,
    Expression<DateTime>? closureStartDate,
    Expression<DateTime>? closureEndDate,
    Expression<String>? closureCustomMessage,
    Expression<String>? logoUrl,
    Expression<double>? tvaRate,
    Expression<String>? googleUrl,
    Expression<String>? pagesJaunesUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (presentation != null) 'presentation': presentation,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (facebookUrl != null) 'facebook_url': facebookUrl,
      if (instagramUrl != null) 'instagram_url': instagramUrl,
      if (xUrl != null) 'x_url': xUrl,
      if (whatsappPhone != null) 'whatsapp_phone': whatsappPhone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (ordersEnabled != null) 'orders_enabled': ordersEnabled,
      if (closureMessageType != null)
        'closure_message_type': closureMessageType,
      if (closureStartDate != null) 'closure_start_date': closureStartDate,
      if (closureEndDate != null) 'closure_end_date': closureEndDate,
      if (closureCustomMessage != null)
        'closure_custom_message': closureCustomMessage,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (tvaRate != null) 'tva_rate': tvaRate,
      if (googleUrl != null) 'google_url': googleUrl,
      if (pagesJaunesUrl != null) 'pagesjaunes_url': pagesJaunesUrl,
    });
  }

  CompanyInfoCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? presentation,
      Value<String?>? address,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? facebookUrl,
      Value<String?>? instagramUrl,
      Value<String?>? xUrl,
      Value<String?>? whatsappPhone,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<bool>? ordersEnabled,
      Value<String?>? closureMessageType,
      Value<DateTime?>? closureStartDate,
      Value<DateTime?>? closureEndDate,
      Value<String?>? closureCustomMessage,
      Value<String?>? logoUrl,
      Value<double?>? tvaRate,
      Value<String?>? googleUrl,
      Value<String?>? pagesJaunesUrl}) {
    return CompanyInfoCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      presentation: presentation ?? this.presentation,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      xUrl: xUrl ?? this.xUrl,
      whatsappPhone: whatsappPhone ?? this.whatsappPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ordersEnabled: ordersEnabled ?? this.ordersEnabled,
      closureMessageType: closureMessageType ?? this.closureMessageType,
      closureStartDate: closureStartDate ?? this.closureStartDate,
      closureEndDate: closureEndDate ?? this.closureEndDate,
      closureCustomMessage: closureCustomMessage ?? this.closureCustomMessage,
      logoUrl: logoUrl ?? this.logoUrl,
      tvaRate: tvaRate ?? this.tvaRate,
      googleUrl: googleUrl ?? this.googleUrl,
      pagesJaunesUrl: pagesJaunesUrl ?? this.pagesJaunesUrl,
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
    if (presentation.present) {
      map['presentation'] = Variable<String>(presentation.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (facebookUrl.present) {
      map['facebook_url'] = Variable<String>(facebookUrl.value);
    }
    if (instagramUrl.present) {
      map['instagram_url'] = Variable<String>(instagramUrl.value);
    }
    if (xUrl.present) {
      map['x_url'] = Variable<String>(xUrl.value);
    }
    if (whatsappPhone.present) {
      map['whatsapp_phone'] = Variable<String>(whatsappPhone.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (ordersEnabled.present) {
      map['orders_enabled'] = Variable<bool>(ordersEnabled.value);
    }
    if (closureMessageType.present) {
      map['closure_message_type'] = Variable<String>(closureMessageType.value);
    }
    if (closureStartDate.present) {
      map['closure_start_date'] = Variable<DateTime>(closureStartDate.value);
    }
    if (closureEndDate.present) {
      map['closure_end_date'] = Variable<DateTime>(closureEndDate.value);
    }
    if (closureCustomMessage.present) {
      map['closure_custom_message'] =
          Variable<String>(closureCustomMessage.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (tvaRate.present) {
      map['tva_rate'] = Variable<double>(tvaRate.value);
    }
    if (googleUrl.present) {
      map['google_url'] = Variable<String>(googleUrl.value);
    }
    if (pagesJaunesUrl.present) {
      map['pagesjaunes_url'] = Variable<String>(pagesJaunesUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompanyInfoCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('presentation: $presentation, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('facebookUrl: $facebookUrl, ')
          ..write('instagramUrl: $instagramUrl, ')
          ..write('xUrl: $xUrl, ')
          ..write('whatsappPhone: $whatsappPhone, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('ordersEnabled: $ordersEnabled, ')
          ..write('closureMessageType: $closureMessageType, ')
          ..write('closureStartDate: $closureStartDate, ')
          ..write('closureEndDate: $closureEndDate, ')
          ..write('closureCustomMessage: $closureCustomMessage, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('tvaRate: $tvaRate, ')
          ..write('googleUrl: $googleUrl, ')
          ..write('pagesJaunesUrl: $pagesJaunesUrl')
          ..write(')'))
        .toString();
  }
}

class $ProductIngredientLinksTable extends ProductIngredientLinks
    with TableInfo<$ProductIngredientLinksTable, ProductIngredientLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductIngredientLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ingredients (id)'));
  static const VerificationMeta _isBaseIngredientMeta =
      const VerificationMeta('isBaseIngredient');
  @override
  late final GeneratedColumn<bool> isBaseIngredient = GeneratedColumn<bool>(
      'is_base_ingredient', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_base_ingredient" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [productId, ingredientId, isBaseIngredient];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_ingredient_links';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductIngredientLink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('is_base_ingredient')) {
      context.handle(
          _isBaseIngredientMeta,
          isBaseIngredient.isAcceptableOrUnknown(
              data['is_base_ingredient']!, _isBaseIngredientMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId, ingredientId};
  @override
  ProductIngredientLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductIngredientLink(
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id'])!,
      isBaseIngredient: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_base_ingredient'])!,
    );
  }

  @override
  $ProductIngredientLinksTable createAlias(String alias) {
    return $ProductIngredientLinksTable(attachedDatabase, alias);
  }
}

class ProductIngredientLink extends DataClass
    implements Insertable<ProductIngredientLink> {
  final int productId;
  final int ingredientId;
  final bool isBaseIngredient;
  const ProductIngredientLink(
      {required this.productId,
      required this.ingredientId,
      required this.isBaseIngredient});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['is_base_ingredient'] = Variable<bool>(isBaseIngredient);
    return map;
  }

  ProductIngredientLinksCompanion toCompanion(bool nullToAbsent) {
    return ProductIngredientLinksCompanion(
      productId: Value(productId),
      ingredientId: Value(ingredientId),
      isBaseIngredient: Value(isBaseIngredient),
    );
  }

  factory ProductIngredientLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductIngredientLink(
      productId: serializer.fromJson<int>(json['productId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      isBaseIngredient: serializer.fromJson<bool>(json['isBaseIngredient']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'isBaseIngredient': serializer.toJson<bool>(isBaseIngredient),
    };
  }

  ProductIngredientLink copyWith(
          {int? productId, int? ingredientId, bool? isBaseIngredient}) =>
      ProductIngredientLink(
        productId: productId ?? this.productId,
        ingredientId: ingredientId ?? this.ingredientId,
        isBaseIngredient: isBaseIngredient ?? this.isBaseIngredient,
      );
  ProductIngredientLink copyWithCompanion(
      ProductIngredientLinksCompanion data) {
    return ProductIngredientLink(
      productId: data.productId.present ? data.productId.value : this.productId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      isBaseIngredient: data.isBaseIngredient.present
          ? data.isBaseIngredient.value
          : this.isBaseIngredient,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductIngredientLink(')
          ..write('productId: $productId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('isBaseIngredient: $isBaseIngredient')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, ingredientId, isBaseIngredient);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductIngredientLink &&
          other.productId == this.productId &&
          other.ingredientId == this.ingredientId &&
          other.isBaseIngredient == this.isBaseIngredient);
}

class ProductIngredientLinksCompanion
    extends UpdateCompanion<ProductIngredientLink> {
  final Value<int> productId;
  final Value<int> ingredientId;
  final Value<bool> isBaseIngredient;
  final Value<int> rowid;
  const ProductIngredientLinksCompanion({
    this.productId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.isBaseIngredient = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductIngredientLinksCompanion.insert({
    required int productId,
    required int ingredientId,
    this.isBaseIngredient = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : productId = Value(productId),
        ingredientId = Value(ingredientId);
  static Insertable<ProductIngredientLink> custom({
    Expression<int>? productId,
    Expression<int>? ingredientId,
    Expression<bool>? isBaseIngredient,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (isBaseIngredient != null) 'is_base_ingredient': isBaseIngredient,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductIngredientLinksCompanion copyWith(
      {Value<int>? productId,
      Value<int>? ingredientId,
      Value<bool>? isBaseIngredient,
      Value<int>? rowid}) {
    return ProductIngredientLinksCompanion(
      productId: productId ?? this.productId,
      ingredientId: ingredientId ?? this.ingredientId,
      isBaseIngredient: isBaseIngredient ?? this.isBaseIngredient,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (isBaseIngredient.present) {
      map['is_base_ingredient'] = Variable<bool>(isBaseIngredient.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductIngredientLinksCompanion(')
          ..write('productId: $productId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('isBaseIngredient: $isBaseIngredient, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedCartItemsTable extends SavedCartItems
    with TableInfo<$SavedCartItemsTable, SavedCartItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedCartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uniqueIdMeta =
      const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String> uniqueId = GeneratedColumn<String>(
      'unique_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _selectedIngredientsMeta =
      const VerificationMeta('selectedIngredients');
  @override
  late final GeneratedColumn<String> selectedIngredients =
      GeneratedColumn<String>('selected_ingredients', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _removedIngredientsMeta =
      const VerificationMeta('removedIngredients');
  @override
  late final GeneratedColumn<String> removedIngredients =
      GeneratedColumn<String>('removed_ingredients', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [uniqueId, productId, quantity, selectedIngredients, removedIngredients];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_cart_items';
  @override
  VerificationContext validateIntegrity(Insertable<SavedCartItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    } else if (isInserting) {
      context.missing(_uniqueIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('selected_ingredients')) {
      context.handle(
          _selectedIngredientsMeta,
          selectedIngredients.isAcceptableOrUnknown(
              data['selected_ingredients']!, _selectedIngredientsMeta));
    } else if (isInserting) {
      context.missing(_selectedIngredientsMeta);
    }
    if (data.containsKey('removed_ingredients')) {
      context.handle(
          _removedIngredientsMeta,
          removedIngredients.isAcceptableOrUnknown(
              data['removed_ingredients']!, _removedIngredientsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uniqueId};
  @override
  SavedCartItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedCartItem(
      uniqueId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unique_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      selectedIngredients: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}selected_ingredients'])!,
      removedIngredients: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}removed_ingredients'])!,
    );
  }

  @override
  $SavedCartItemsTable createAlias(String alias) {
    return $SavedCartItemsTable(attachedDatabase, alias);
  }
}

class SavedCartItem extends DataClass implements Insertable<SavedCartItem> {
  final String uniqueId;
  final int productId;
  final int quantity;
  final String selectedIngredients;
  final String removedIngredients;
  const SavedCartItem(
      {required this.uniqueId,
      required this.productId,
      required this.quantity,
      required this.selectedIngredients,
      required this.removedIngredients});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unique_id'] = Variable<String>(uniqueId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['selected_ingredients'] = Variable<String>(selectedIngredients);
    map['removed_ingredients'] = Variable<String>(removedIngredients);
    return map;
  }

  SavedCartItemsCompanion toCompanion(bool nullToAbsent) {
    return SavedCartItemsCompanion(
      uniqueId: Value(uniqueId),
      productId: Value(productId),
      quantity: Value(quantity),
      selectedIngredients: Value(selectedIngredients),
      removedIngredients: Value(removedIngredients),
    );
  }

  factory SavedCartItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedCartItem(
      uniqueId: serializer.fromJson<String>(json['uniqueId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      selectedIngredients:
          serializer.fromJson<String>(json['selectedIngredients']),
      removedIngredients:
          serializer.fromJson<String>(json['removedIngredients']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uniqueId': serializer.toJson<String>(uniqueId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'selectedIngredients': serializer.toJson<String>(selectedIngredients),
      'removedIngredients': serializer.toJson<String>(removedIngredients),
    };
  }

  SavedCartItem copyWith(
          {String? uniqueId,
          int? productId,
          int? quantity,
          String? selectedIngredients,
          String? removedIngredients}) =>
      SavedCartItem(
        uniqueId: uniqueId ?? this.uniqueId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        selectedIngredients: selectedIngredients ?? this.selectedIngredients,
        removedIngredients: removedIngredients ?? this.removedIngredients,
      );
  SavedCartItem copyWithCompanion(SavedCartItemsCompanion data) {
    return SavedCartItem(
      uniqueId: data.uniqueId.present ? data.uniqueId.value : this.uniqueId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      selectedIngredients: data.selectedIngredients.present
          ? data.selectedIngredients.value
          : this.selectedIngredients,
      removedIngredients: data.removedIngredients.present
          ? data.removedIngredients.value
          : this.removedIngredients,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedCartItem(')
          ..write('uniqueId: $uniqueId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('selectedIngredients: $selectedIngredients, ')
          ..write('removedIngredients: $removedIngredients')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      uniqueId, productId, quantity, selectedIngredients, removedIngredients);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedCartItem &&
          other.uniqueId == this.uniqueId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.selectedIngredients == this.selectedIngredients &&
          other.removedIngredients == this.removedIngredients);
}

class SavedCartItemsCompanion extends UpdateCompanion<SavedCartItem> {
  final Value<String> uniqueId;
  final Value<int> productId;
  final Value<int> quantity;
  final Value<String> selectedIngredients;
  final Value<String> removedIngredients;
  final Value<int> rowid;
  const SavedCartItemsCompanion({
    this.uniqueId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.selectedIngredients = const Value.absent(),
    this.removedIngredients = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedCartItemsCompanion.insert({
    required String uniqueId,
    required int productId,
    required int quantity,
    required String selectedIngredients,
    this.removedIngredients = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : uniqueId = Value(uniqueId),
        productId = Value(productId),
        quantity = Value(quantity),
        selectedIngredients = Value(selectedIngredients);
  static Insertable<SavedCartItem> custom({
    Expression<String>? uniqueId,
    Expression<int>? productId,
    Expression<int>? quantity,
    Expression<String>? selectedIngredients,
    Expression<String>? removedIngredients,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uniqueId != null) 'unique_id': uniqueId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (selectedIngredients != null)
        'selected_ingredients': selectedIngredients,
      if (removedIngredients != null) 'removed_ingredients': removedIngredients,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedCartItemsCompanion copyWith(
      {Value<String>? uniqueId,
      Value<int>? productId,
      Value<int>? quantity,
      Value<String>? selectedIngredients,
      Value<String>? removedIngredients,
      Value<int>? rowid}) {
    return SavedCartItemsCompanion(
      uniqueId: uniqueId ?? this.uniqueId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      removedIngredients: removedIngredients ?? this.removedIngredients,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (selectedIngredients.present) {
      map['selected_ingredients'] = Variable<String>(selectedIngredients.value);
    }
    if (removedIngredients.present) {
      map['removed_ingredients'] = Variable<String>(removedIngredients.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedCartItemsCompanion(')
          ..write('uniqueId: $uniqueId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('selectedIngredients: $selectedIngredients, ')
          ..write('removedIngredients: $removedIngredients, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderStatusHistoriesTable extends OrderStatusHistories
    with TableInfo<$OrderStatusHistoriesTable, OrderStatusHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderStatusHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, orderId, status, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_status_histories';
  @override
  VerificationContext validateIntegrity(Insertable<OrderStatusHistory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderStatusHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderStatusHistory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OrderStatusHistoriesTable createAlias(String alias) {
    return $OrderStatusHistoriesTable(attachedDatabase, alias);
  }
}

class OrderStatusHistory extends DataClass
    implements Insertable<OrderStatusHistory> {
  final int id;
  final int orderId;
  final String status;
  final DateTime createdAt;
  const OrderStatusHistory(
      {required this.id,
      required this.orderId,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrderStatusHistoriesCompanion toCompanion(bool nullToAbsent) {
    return OrderStatusHistoriesCompanion(
      id: Value(id),
      orderId: Value(orderId),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderStatusHistory(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OrderStatusHistory copyWith(
          {int? id, int? orderId, String? status, DateTime? createdAt}) =>
      OrderStatusHistory(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  OrderStatusHistory copyWithCompanion(OrderStatusHistoriesCompanion data) {
    return OrderStatusHistory(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderStatusHistory(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderStatusHistory &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class OrderStatusHistoriesCompanion
    extends UpdateCompanion<OrderStatusHistory> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const OrderStatusHistoriesCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OrderStatusHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required String status,
    required DateTime createdAt,
  })  : orderId = Value(orderId),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<OrderStatusHistory> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OrderStatusHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return OrderStatusHistoriesCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderStatusHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LoyaltySettingsTable extends LoyaltySettings
    with TableInfo<$LoyaltySettingsTable, LoyaltySetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoyaltySettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('free_pizza'));
  static const VerificationMeta _thresholdMeta =
      const VerificationMeta('threshold');
  @override
  late final GeneratedColumn<int> threshold = GeneratedColumn<int>(
      'threshold', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>('discount_percentage', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, isEnabled, mode, threshold, discountPercentage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loyalty_settings';
  @override
  VerificationContext validateIntegrity(Insertable<LoyaltySetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    }
    if (data.containsKey('threshold')) {
      context.handle(_thresholdMeta,
          threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta));
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
          _discountPercentageMeta,
          discountPercentage.isAcceptableOrUnknown(
              data['discount_percentage']!, _discountPercentageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoyaltySetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoyaltySetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      threshold: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}threshold'])!,
      discountPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_percentage'])!,
    );
  }

  @override
  $LoyaltySettingsTable createAlias(String alias) {
    return $LoyaltySettingsTable(attachedDatabase, alias);
  }
}

class LoyaltySetting extends DataClass implements Insertable<LoyaltySetting> {
  final int id;
  final bool isEnabled;
  final String mode;
  final int threshold;
  final double discountPercentage;
  const LoyaltySetting(
      {required this.id,
      required this.isEnabled,
      required this.mode,
      required this.threshold,
      required this.discountPercentage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['mode'] = Variable<String>(mode);
    map['threshold'] = Variable<int>(threshold);
    map['discount_percentage'] = Variable<double>(discountPercentage);
    return map;
  }

  LoyaltySettingsCompanion toCompanion(bool nullToAbsent) {
    return LoyaltySettingsCompanion(
      id: Value(id),
      isEnabled: Value(isEnabled),
      mode: Value(mode),
      threshold: Value(threshold),
      discountPercentage: Value(discountPercentage),
    );
  }

  factory LoyaltySetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoyaltySetting(
      id: serializer.fromJson<int>(json['id']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      mode: serializer.fromJson<String>(json['mode']),
      threshold: serializer.fromJson<int>(json['threshold']),
      discountPercentage:
          serializer.fromJson<double>(json['discountPercentage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'mode': serializer.toJson<String>(mode),
      'threshold': serializer.toJson<int>(threshold),
      'discountPercentage': serializer.toJson<double>(discountPercentage),
    };
  }

  LoyaltySetting copyWith(
          {int? id,
          bool? isEnabled,
          String? mode,
          int? threshold,
          double? discountPercentage}) =>
      LoyaltySetting(
        id: id ?? this.id,
        isEnabled: isEnabled ?? this.isEnabled,
        mode: mode ?? this.mode,
        threshold: threshold ?? this.threshold,
        discountPercentage: discountPercentage ?? this.discountPercentage,
      );
  LoyaltySetting copyWithCompanion(LoyaltySettingsCompanion data) {
    return LoyaltySetting(
      id: data.id.present ? data.id.value : this.id,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      mode: data.mode.present ? data.mode.value : this.mode,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoyaltySetting(')
          ..write('id: $id, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('mode: $mode, ')
          ..write('threshold: $threshold, ')
          ..write('discountPercentage: $discountPercentage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, isEnabled, mode, threshold, discountPercentage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoyaltySetting &&
          other.id == this.id &&
          other.isEnabled == this.isEnabled &&
          other.mode == this.mode &&
          other.threshold == this.threshold &&
          other.discountPercentage == this.discountPercentage);
}

class LoyaltySettingsCompanion extends UpdateCompanion<LoyaltySetting> {
  final Value<int> id;
  final Value<bool> isEnabled;
  final Value<String> mode;
  final Value<int> threshold;
  final Value<double> discountPercentage;
  const LoyaltySettingsCompanion({
    this.id = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.threshold = const Value.absent(),
    this.discountPercentage = const Value.absent(),
  });
  LoyaltySettingsCompanion.insert({
    this.id = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.threshold = const Value.absent(),
    this.discountPercentage = const Value.absent(),
  });
  static Insertable<LoyaltySetting> custom({
    Expression<int>? id,
    Expression<bool>? isEnabled,
    Expression<String>? mode,
    Expression<int>? threshold,
    Expression<double>? discountPercentage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (mode != null) 'mode': mode,
      if (threshold != null) 'threshold': threshold,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
    });
  }

  LoyaltySettingsCompanion copyWith(
      {Value<int>? id,
      Value<bool>? isEnabled,
      Value<String>? mode,
      Value<int>? threshold,
      Value<double>? discountPercentage}) {
    return LoyaltySettingsCompanion(
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      mode: mode ?? this.mode,
      threshold: threshold ?? this.threshold,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<int>(threshold.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoyaltySettingsCompanion(')
          ..write('id: $id, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('mode: $mode, ')
          ..write('threshold: $threshold, ')
          ..write('discountPercentage: $discountPercentage')
          ..write(')'))
        .toString();
  }
}

class $UserLoyaltiesTable extends UserLoyalties
    with TableInfo<$UserLoyaltiesTable, UserLoyalty> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserLoyaltiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
      'points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pizzaCountMeta =
      const VerificationMeta('pizzaCount');
  @override
  late final GeneratedColumn<int> pizzaCount = GeneratedColumn<int>(
      'pizza_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [userId, points, pizzaCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_loyalties';
  @override
  VerificationContext validateIntegrity(Insertable<UserLoyalty> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    }
    if (data.containsKey('pizza_count')) {
      context.handle(
          _pizzaCountMeta,
          pizzaCount.isAcceptableOrUnknown(
              data['pizza_count']!, _pizzaCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserLoyalty map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLoyalty(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      points: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}points'])!,
      pizzaCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pizza_count'])!,
    );
  }

  @override
  $UserLoyaltiesTable createAlias(String alias) {
    return $UserLoyaltiesTable(attachedDatabase, alias);
  }
}

class UserLoyalty extends DataClass implements Insertable<UserLoyalty> {
  final String userId;
  final int points;
  final int pizzaCount;
  const UserLoyalty(
      {required this.userId, required this.points, required this.pizzaCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['points'] = Variable<int>(points);
    map['pizza_count'] = Variable<int>(pizzaCount);
    return map;
  }

  UserLoyaltiesCompanion toCompanion(bool nullToAbsent) {
    return UserLoyaltiesCompanion(
      userId: Value(userId),
      points: Value(points),
      pizzaCount: Value(pizzaCount),
    );
  }

  factory UserLoyalty.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserLoyalty(
      userId: serializer.fromJson<String>(json['userId']),
      points: serializer.fromJson<int>(json['points']),
      pizzaCount: serializer.fromJson<int>(json['pizzaCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'points': serializer.toJson<int>(points),
      'pizzaCount': serializer.toJson<int>(pizzaCount),
    };
  }

  UserLoyalty copyWith({String? userId, int? points, int? pizzaCount}) =>
      UserLoyalty(
        userId: userId ?? this.userId,
        points: points ?? this.points,
        pizzaCount: pizzaCount ?? this.pizzaCount,
      );
  UserLoyalty copyWithCompanion(UserLoyaltiesCompanion data) {
    return UserLoyalty(
      userId: data.userId.present ? data.userId.value : this.userId,
      points: data.points.present ? data.points.value : this.points,
      pizzaCount:
          data.pizzaCount.present ? data.pizzaCount.value : this.pizzaCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserLoyalty(')
          ..write('userId: $userId, ')
          ..write('points: $points, ')
          ..write('pizzaCount: $pizzaCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, points, pizzaCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserLoyalty &&
          other.userId == this.userId &&
          other.points == this.points &&
          other.pizzaCount == this.pizzaCount);
}

class UserLoyaltiesCompanion extends UpdateCompanion<UserLoyalty> {
  final Value<String> userId;
  final Value<int> points;
  final Value<int> pizzaCount;
  final Value<int> rowid;
  const UserLoyaltiesCompanion({
    this.userId = const Value.absent(),
    this.points = const Value.absent(),
    this.pizzaCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserLoyaltiesCompanion.insert({
    required String userId,
    this.points = const Value.absent(),
    this.pizzaCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserLoyalty> custom({
    Expression<String>? userId,
    Expression<int>? points,
    Expression<int>? pizzaCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (points != null) 'points': points,
      if (pizzaCount != null) 'pizza_count': pizzaCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserLoyaltiesCompanion copyWith(
      {Value<String>? userId,
      Value<int>? points,
      Value<int>? pizzaCount,
      Value<int>? rowid}) {
    return UserLoyaltiesCompanion(
      userId: userId ?? this.userId,
      points: points ?? this.points,
      pizzaCount: pizzaCount ?? this.pizzaCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (pizzaCount.present) {
      map['pizza_count'] = Variable<int>(pizzaCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserLoyaltiesCompanion(')
          ..write('userId: $userId, ')
          ..write('points: $points, ')
          ..write('pizzaCount: $pizzaCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductOptionsTable extends ProductOptions
    with TableInfo<$ProductOptionsTable, ProductOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isGlobalMeta =
      const VerificationMeta('isGlobal');
  @override
  late final GeneratedColumn<bool> isGlobal = GeneratedColumn<bool>(
      'is_global', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_global" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, name, price, isGlobal, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_options';
  @override
  VerificationContext validateIntegrity(Insertable<ProductOption> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('is_global')) {
      context.handle(_isGlobalMeta,
          isGlobal.isAcceptableOrUnknown(data['is_global']!, _isGlobalMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductOption(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      isGlobal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_global'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
    );
  }

  @override
  $ProductOptionsTable createAlias(String alias) {
    return $ProductOptionsTable(attachedDatabase, alias);
  }
}

class ProductOption extends DataClass implements Insertable<ProductOption> {
  final int id;
  final int? productId;
  final String name;
  final double price;
  final bool isGlobal;
  final String? category;
  const ProductOption(
      {required this.id,
      this.productId,
      required this.name,
      required this.price,
      required this.isGlobal,
      this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['is_global'] = Variable<bool>(isGlobal);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  ProductOptionsCompanion toCompanion(bool nullToAbsent) {
    return ProductOptionsCompanion(
      id: Value(id),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      name: Value(name),
      price: Value(price),
      isGlobal: Value(isGlobal),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory ProductOption.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductOption(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int?>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      isGlobal: serializer.fromJson<bool>(json['isGlobal']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int?>(productId),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'isGlobal': serializer.toJson<bool>(isGlobal),
      'category': serializer.toJson<String?>(category),
    };
  }

  ProductOption copyWith(
          {int? id,
          Value<int?> productId = const Value.absent(),
          String? name,
          double? price,
          bool? isGlobal,
          Value<String?> category = const Value.absent()}) =>
      ProductOption(
        id: id ?? this.id,
        productId: productId.present ? productId.value : this.productId,
        name: name ?? this.name,
        price: price ?? this.price,
        isGlobal: isGlobal ?? this.isGlobal,
        category: category.present ? category.value : this.category,
      );
  ProductOption copyWithCompanion(ProductOptionsCompanion data) {
    return ProductOption(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      isGlobal: data.isGlobal.present ? data.isGlobal.value : this.isGlobal,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductOption(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, name, price, isGlobal, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductOption &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.price == this.price &&
          other.isGlobal == this.isGlobal &&
          other.category == this.category);
}

class ProductOptionsCompanion extends UpdateCompanion<ProductOption> {
  final Value<int> id;
  final Value<int?> productId;
  final Value<String> name;
  final Value<double> price;
  final Value<bool> isGlobal;
  final Value<String?> category;
  const ProductOptionsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.isGlobal = const Value.absent(),
    this.category = const Value.absent(),
  });
  ProductOptionsCompanion.insert({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    required String name,
    required double price,
    this.isGlobal = const Value.absent(),
    this.category = const Value.absent(),
  })  : name = Value(name),
        price = Value(price);
  static Insertable<ProductOption> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? name,
    Expression<double>? price,
    Expression<bool>? isGlobal,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (isGlobal != null) 'is_global': isGlobal,
      if (category != null) 'category': category,
    });
  }

  ProductOptionsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? productId,
      Value<String>? name,
      Value<double>? price,
      Value<bool>? isGlobal,
      Value<String?>? category}) {
    return ProductOptionsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      isGlobal: isGlobal ?? this.isGlobal,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (isGlobal.present) {
      map['is_global'] = Variable<bool>(isGlobal.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductOptionsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $ProductOptionLinksTable extends ProductOptionLinks
    with TableInfo<$ProductOptionLinksTable, ProductOptionLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductOptionLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _optionIdMeta =
      const VerificationMeta('optionId');
  @override
  late final GeneratedColumn<int> optionId = GeneratedColumn<int>(
      'option_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_options (id)'));
  @override
  List<GeneratedColumn> get $columns => [productId, optionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_option_links';
  @override
  VerificationContext validateIntegrity(Insertable<ProductOptionLink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('option_id')) {
      context.handle(_optionIdMeta,
          optionId.isAcceptableOrUnknown(data['option_id']!, _optionIdMeta));
    } else if (isInserting) {
      context.missing(_optionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId, optionId};
  @override
  ProductOptionLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductOptionLink(
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      optionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}option_id'])!,
    );
  }

  @override
  $ProductOptionLinksTable createAlias(String alias) {
    return $ProductOptionLinksTable(attachedDatabase, alias);
  }
}

class ProductOptionLink extends DataClass
    implements Insertable<ProductOptionLink> {
  final int productId;
  final int optionId;
  const ProductOptionLink({required this.productId, required this.optionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['option_id'] = Variable<int>(optionId);
    return map;
  }

  ProductOptionLinksCompanion toCompanion(bool nullToAbsent) {
    return ProductOptionLinksCompanion(
      productId: Value(productId),
      optionId: Value(optionId),
    );
  }

  factory ProductOptionLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductOptionLink(
      productId: serializer.fromJson<int>(json['productId']),
      optionId: serializer.fromJson<int>(json['optionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'optionId': serializer.toJson<int>(optionId),
    };
  }

  ProductOptionLink copyWith({int? productId, int? optionId}) =>
      ProductOptionLink(
        productId: productId ?? this.productId,
        optionId: optionId ?? this.optionId,
      );
  ProductOptionLink copyWithCompanion(ProductOptionLinksCompanion data) {
    return ProductOptionLink(
      productId: data.productId.present ? data.productId.value : this.productId,
      optionId: data.optionId.present ? data.optionId.value : this.optionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductOptionLink(')
          ..write('productId: $productId, ')
          ..write('optionId: $optionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, optionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductOptionLink &&
          other.productId == this.productId &&
          other.optionId == this.optionId);
}

class ProductOptionLinksCompanion extends UpdateCompanion<ProductOptionLink> {
  final Value<int> productId;
  final Value<int> optionId;
  final Value<int> rowid;
  const ProductOptionLinksCompanion({
    this.productId = const Value.absent(),
    this.optionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductOptionLinksCompanion.insert({
    required int productId,
    required int optionId,
    this.rowid = const Value.absent(),
  })  : productId = Value(productId),
        optionId = Value(optionId);
  static Insertable<ProductOptionLink> custom({
    Expression<int>? productId,
    Expression<int>? optionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (optionId != null) 'option_id': optionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductOptionLinksCompanion copyWith(
      {Value<int>? productId, Value<int>? optionId, Value<int>? rowid}) {
    return ProductOptionLinksCompanion(
      productId: productId ?? this.productId,
      optionId: optionId ?? this.optionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (optionId.present) {
      map['option_id'] = Variable<int>(optionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductOptionLinksCompanion(')
          ..write('productId: $productId, ')
          ..write('optionId: $optionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $ReviewsTable reviews = $ReviewsTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $AdminsTable admins = $AdminsTable(this);
  late final $AnnouncementsTable announcements = $AnnouncementsTable(this);
  late final $CompanyInfoTable companyInfo = $CompanyInfoTable(this);
  late final $ProductIngredientLinksTable productIngredientLinks =
      $ProductIngredientLinksTable(this);
  late final $SavedCartItemsTable savedCartItems = $SavedCartItemsTable(this);
  late final $OrderStatusHistoriesTable orderStatusHistories =
      $OrderStatusHistoriesTable(this);
  late final $LoyaltySettingsTable loyaltySettings =
      $LoyaltySettingsTable(this);
  late final $UserLoyaltiesTable userLoyalties = $UserLoyaltiesTable(this);
  late final $ProductOptionsTable productOptions = $ProductOptionsTable(this);
  late final $ProductOptionLinksTable productOptionLinks =
      $ProductOptionLinksTable(this);
  late final ProductDao productDao = ProductDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        products,
        users,
        orders,
        orderItems,
        reviews,
        ingredients,
        admins,
        announcements,
        companyInfo,
        productIngredientLinks,
        savedCartItems,
        orderStatusHistories,
        loyaltySettings,
        userLoyalties,
        productOptions,
        productOptionLinks
      ];
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required double basePrice,
  Value<String?> image,
  Value<String?> category,
  Value<bool> hasGlobalDiscount,
  Value<double> discountPercentage,
  Value<int?> maxSupplements,
  Value<bool> isActive,
  Value<bool> isDrink,
  required DateTime createdAt,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<double> basePrice,
  Value<String?> image,
  Value<String?> category,
  Value<bool> hasGlobalDiscount,
  Value<double> discountPercentage,
  Value<int?> maxSupplements,
  Value<bool> isActive,
  Value<bool> isDrink,
  Value<DateTime> createdAt,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductIngredientLinksTable,
      List<ProductIngredientLink>> _productIngredientLinksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.productIngredientLinks,
          aliasName: $_aliasNameGenerator(
              db.products.id, db.productIngredientLinks.productId));

  $$ProductIngredientLinksTableProcessedTableManager
      get productIngredientLinksRefs {
    final manager = $$ProductIngredientLinksTableTableManager(
            $_db, $_db.productIngredientLinks)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_productIngredientLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProductOptionsTable, List<ProductOption>>
      _productOptionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productOptions,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.productOptions.productId));

  $$ProductOptionsTableProcessedTableManager get productOptionsRefs {
    final manager = $$ProductOptionsTableTableManager($_db, $_db.productOptions)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productOptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProductOptionLinksTable, List<ProductOptionLink>>
      _productOptionLinksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productOptionLinks,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.productOptionLinks.productId));

  $$ProductOptionLinksTableProcessedTableManager get productOptionLinksRefs {
    final manager =
        $$ProductOptionLinksTableTableManager($_db, $_db.productOptionLinks)
            .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_productOptionLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  ColumnFilters<bool> get hasGlobalDiscount => $composableBuilder(
      column: $table.hasGlobalDiscount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxSupplements => $composableBuilder(
      column: $table.maxSupplements,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDrink => $composableBuilder(
      column: $table.isDrink, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> productIngredientLinksRefs(
      Expression<bool> Function($$ProductIngredientLinksTableFilterComposer f)
          f) {
    final $$ProductIngredientLinksTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productIngredientLinks,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductIngredientLinksTableFilterComposer(
                  $db: $db,
                  $table: $db.productIngredientLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> productOptionsRefs(
      Expression<bool> Function($$ProductOptionsTableFilterComposer f) f) {
    final $$ProductOptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productOptions,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOptionsTableFilterComposer(
              $db: $db,
              $table: $db.productOptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> productOptionLinksRefs(
      Expression<bool> Function($$ProductOptionLinksTableFilterComposer f) f) {
    final $$ProductOptionLinksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productOptionLinks,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOptionLinksTableFilterComposer(
              $db: $db,
              $table: $db.productOptionLinks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  ColumnOrderings<bool> get hasGlobalDiscount => $composableBuilder(
      column: $table.hasGlobalDiscount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxSupplements => $composableBuilder(
      column: $table.maxSupplements,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDrink => $composableBuilder(
      column: $table.isDrink, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<bool> get hasGlobalDiscount => $composableBuilder(
      column: $table.hasGlobalDiscount, builder: (column) => column);

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage, builder: (column) => column);

  GeneratedColumn<int> get maxSupplements => $composableBuilder(
      column: $table.maxSupplements, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDrink =>
      $composableBuilder(column: $table.isDrink, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> productIngredientLinksRefs<T extends Object>(
      Expression<T> Function($$ProductIngredientLinksTableAnnotationComposer a)
          f) {
    final $$ProductIngredientLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productIngredientLinks,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductIngredientLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productIngredientLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> productOptionsRefs<T extends Object>(
      Expression<T> Function($$ProductOptionsTableAnnotationComposer a) f) {
    final $$ProductOptionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productOptions,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOptionsTableAnnotationComposer(
              $db: $db,
              $table: $db.productOptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> productOptionLinksRefs<T extends Object>(
      Expression<T> Function($$ProductOptionLinksTableAnnotationComposer a) f) {
    final $$ProductOptionLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productOptionLinks,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductOptionLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productOptionLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
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
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool productIngredientLinksRefs,
        bool productOptionsRefs,
        bool productOptionLinksRefs})> {
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
            Value<bool> hasGlobalDiscount = const Value.absent(),
            Value<double> discountPercentage = const Value.absent(),
            Value<int?> maxSupplements = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDrink = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            description: description,
            basePrice: basePrice,
            image: image,
            category: category,
            hasGlobalDiscount: hasGlobalDiscount,
            discountPercentage: discountPercentage,
            maxSupplements: maxSupplements,
            isActive: isActive,
            isDrink: isDrink,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required double basePrice,
            Value<String?> image = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> hasGlobalDiscount = const Value.absent(),
            Value<double> discountPercentage = const Value.absent(),
            Value<int?> maxSupplements = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDrink = const Value.absent(),
            required DateTime createdAt,
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            description: description,
            basePrice: basePrice,
            image: image,
            category: category,
            hasGlobalDiscount: hasGlobalDiscount,
            discountPercentage: discountPercentage,
            maxSupplements: maxSupplements,
            isActive: isActive,
            isDrink: isDrink,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {productIngredientLinksRefs = false,
              productOptionsRefs = false,
              productOptionLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productIngredientLinksRefs) db.productIngredientLinks,
                if (productOptionsRefs) db.productOptions,
                if (productOptionLinksRefs) db.productOptionLinks
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productIngredientLinksRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductIngredientLink>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productIngredientLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productIngredientLinksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (productOptionsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductOption>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productOptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productOptionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (productOptionLinksRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductOptionLink>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productOptionLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productOptionLinksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool productIngredientLinksRefs,
        bool productOptionsRefs,
        bool productOptionLinksRefs})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  Value<String?> name,
  required String email,
  Value<String?> postalCode,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<String> email,
  Value<String?> postalCode,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReviewsTable, List<Review>> _reviewsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.reviews,
          aliasName: $_aliasNameGenerator(db.users.id, db.reviews.userId));

  $$ReviewsTableProcessedTableManager get reviewsRefs {
    final manager = $$ReviewsTableTableManager($_db, $_db.reviews)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UserLoyaltiesTable, List<UserLoyalty>>
      _userLoyaltiesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.userLoyalties,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.userLoyalties.userId));

  $$UserLoyaltiesTableProcessedTableManager get userLoyaltiesRefs {
    final manager = $$UserLoyaltiesTableTableManager($_db, $_db.userLoyalties)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userLoyaltiesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> reviewsRefs(
      Expression<bool> Function($$ReviewsTableFilterComposer f) f) {
    final $$ReviewsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviews,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewsTableFilterComposer(
              $db: $db,
              $table: $db.reviews,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> userLoyaltiesRefs(
      Expression<bool> Function($$UserLoyaltiesTableFilterComposer f) f) {
    final $$UserLoyaltiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userLoyalties,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserLoyaltiesTableFilterComposer(
              $db: $db,
              $table: $db.userLoyalties,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> reviewsRefs<T extends Object>(
      Expression<T> Function($$ReviewsTableAnnotationComposer a) f) {
    final $$ReviewsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviews,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewsTableAnnotationComposer(
              $db: $db,
              $table: $db.reviews,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> userLoyaltiesRefs<T extends Object>(
      Expression<T> Function($$UserLoyaltiesTableAnnotationComposer a) f) {
    final $$UserLoyaltiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userLoyalties,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserLoyaltiesTableAnnotationComposer(
              $db: $db,
              $table: $db.userLoyalties,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool reviewsRefs, bool userLoyaltiesRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String?> postalCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            email: email,
            postalCode: postalCode,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            required String email,
            Value<String?> postalCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            email: email,
            postalCode: postalCode,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {reviewsRefs = false, userLoyaltiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (reviewsRefs) db.reviews,
                if (userLoyaltiesRefs) db.userLoyalties
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reviewsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Review>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._reviewsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).reviewsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (userLoyaltiesRefs)
                    await $_getPrefetchedData<User, $UsersTable, UserLoyalty>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._userLoyaltiesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .userLoyaltiesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool reviewsRefs, bool userLoyaltiesRefs})>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  required String userId,
  Value<String?> referenceName,
  Value<String?> pickupTime,
  Value<String?> paymentMethod,
  required double total,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<bool?> isArchived,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<String?> referenceName,
  Value<String?> pickupTime,
  Value<String?> paymentMethod,
  Value<double> total,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool?> isArchived,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReviewsTable, List<Review>> _reviewsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.reviews,
          aliasName: $_aliasNameGenerator(db.orders.id, db.reviews.orderId));

  $$ReviewsTableProcessedTableManager get reviewsRefs {
    final manager = $$ReviewsTableTableManager($_db, $_db.reviews)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OrderStatusHistoriesTable,
      List<OrderStatusHistory>> _orderStatusHistoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.orderStatusHistories,
          aliasName: $_aliasNameGenerator(
              db.orders.id, db.orderStatusHistories.orderId));

  $$OrderStatusHistoriesTableProcessedTableManager
      get orderStatusHistoriesRefs {
    final manager =
        $$OrderStatusHistoriesTableTableManager($_db, $_db.orderStatusHistories)
            .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_orderStatusHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceName => $composableBuilder(
      column: $table.referenceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pickupTime => $composableBuilder(
      column: $table.pickupTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reviewsRefs(
      Expression<bool> Function($$ReviewsTableFilterComposer f) f) {
    final $$ReviewsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviews,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewsTableFilterComposer(
              $db: $db,
              $table: $db.reviews,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> orderStatusHistoriesRefs(
      Expression<bool> Function($$OrderStatusHistoriesTableFilterComposer f)
          f) {
    final $$OrderStatusHistoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderStatusHistories,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderStatusHistoriesTableFilterComposer(
              $db: $db,
              $table: $db.orderStatusHistories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceName => $composableBuilder(
      column: $table.referenceName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pickupTime => $composableBuilder(
      column: $table.pickupTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get referenceName => $composableBuilder(
      column: $table.referenceName, builder: (column) => column);

  GeneratedColumn<String> get pickupTime => $composableBuilder(
      column: $table.pickupTime, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reviewsRefs<T extends Object>(
      Expression<T> Function($$ReviewsTableAnnotationComposer a) f) {
    final $$ReviewsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviews,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewsTableAnnotationComposer(
              $db: $db,
              $table: $db.reviews,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> orderStatusHistoriesRefs<T extends Object>(
      Expression<T> Function($$OrderStatusHistoriesTableAnnotationComposer a)
          f) {
    final $$OrderStatusHistoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.orderStatusHistories,
            getReferencedColumn: (t) => t.orderId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OrderStatusHistoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.orderStatusHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function(
        {bool orderItemsRefs,
        bool reviewsRefs,
        bool orderStatusHistoriesRefs})> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> referenceName = const Value.absent(),
            Value<String?> pickupTime = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool?> isArchived = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            userId: userId,
            referenceName: referenceName,
            pickupTime: pickupTime,
            paymentMethod: paymentMethod,
            total: total,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isArchived: isArchived,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            Value<String?> referenceName = const Value.absent(),
            Value<String?> pickupTime = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            required double total,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool?> isArchived = const Value.absent(),
          }) =>
              OrdersCompanion.insert(
            id: id,
            userId: userId,
            referenceName: referenceName,
            pickupTime: pickupTime,
            paymentMethod: paymentMethod,
            total: total,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isArchived: isArchived,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OrdersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {orderItemsRefs = false,
              reviewsRefs = false,
              orderStatusHistoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderItemsRefs) db.orderItems,
                if (reviewsRefs) db.reviews,
                if (orderStatusHistoriesRefs) db.orderStatusHistories
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items),
                  if (reviewsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, Review>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._reviewsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0).reviewsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items),
                  if (orderStatusHistoriesRefs)
                    await $_getPrefetchedData<Order, $OrdersTable,
                            OrderStatusHistory>(
                        currentTable: table,
                        referencedTable: $$OrdersTableReferences
                            ._orderStatusHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .orderStatusHistoriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function(
        {bool orderItemsRefs,
        bool reviewsRefs,
        bool orderStatusHistoriesRefs})>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required int productId,
  required int quantity,
  required double unitPrice,
  required String productName,
  Value<String?> optionsDescription,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> productId,
  Value<int> quantity,
  Value<double> unitPrice,
  Value<String> productName,
  Value<String?> optionsDescription,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.orderItems.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionsDescription => $composableBuilder(
      column: $table.optionsDescription,
      builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionsDescription => $composableBuilder(
      column: $table.optionsDescription,
      builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<String> get optionsDescription => $composableBuilder(
      column: $table.optionsDescription, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId})> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<String?> optionsDescription = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            productId: productId,
            quantity: quantity,
            unitPrice: unitPrice,
            productName: productName,
            optionsDescription: optionsDescription,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int productId,
            required int quantity,
            required double unitPrice,
            required String productName,
            Value<String?> optionsDescription = const Value.absent(),
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            productId: productId,
            quantity: quantity,
            unitPrice: unitPrice,
            productName: productName,
            optionsDescription: optionsDescription,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderItemsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._orderIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId})>;
typedef $$ReviewsTableCreateCompanionBuilder = ReviewsCompanion Function({
  Value<int> id,
  required int orderId,
  required String userId,
  required int rating,
  Value<String?> comment,
  Value<DateTime> createdAt,
});
typedef $$ReviewsTableUpdateCompanionBuilder = ReviewsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<String> userId,
  Value<int> rating,
  Value<String?> comment,
  Value<DateTime> createdAt,
});

final class $$ReviewsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewsTable, Review> {
  $$ReviewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.reviews.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.reviews.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReviewsTable,
    Review,
    $$ReviewsTableFilterComposer,
    $$ReviewsTableOrderingComposer,
    $$ReviewsTableAnnotationComposer,
    $$ReviewsTableCreateCompanionBuilder,
    $$ReviewsTableUpdateCompanionBuilder,
    (Review, $$ReviewsTableReferences),
    Review,
    PrefetchHooks Function({bool orderId, bool userId})> {
  $$ReviewsTableTableManager(_$AppDatabase db, $ReviewsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReviewsCompanion(
            id: id,
            orderId: orderId,
            userId: userId,
            rating: rating,
            comment: comment,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required String userId,
            required int rating,
            Value<String?> comment = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReviewsCompanion.insert(
            id: id,
            orderId: orderId,
            userId: userId,
            rating: rating,
            comment: comment,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ReviewsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({orderId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable: $$ReviewsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$ReviewsTableReferences._orderIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$ReviewsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$ReviewsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReviewsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReviewsTable,
    Review,
    $$ReviewsTableFilterComposer,
    $$ReviewsTableOrderingComposer,
    $$ReviewsTableAnnotationComposer,
    $$ReviewsTableCreateCompanionBuilder,
    $$ReviewsTableUpdateCompanionBuilder,
    (Review, $$ReviewsTableReferences),
    Review,
    PrefetchHooks Function({bool orderId, bool userId})>;
typedef $$IngredientsTableCreateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  required String name,
  required double price,
  Value<String?> category,
  Value<bool> isGlobal,
  Value<DateTime> createdAt,
});
typedef $$IngredientsTableUpdateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<double> price,
  Value<String?> category,
  Value<bool> isGlobal,
  Value<DateTime> createdAt,
});

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductIngredientLinksTable,
      List<ProductIngredientLink>> _productIngredientLinksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.productIngredientLinks,
          aliasName: $_aliasNameGenerator(
              db.ingredients.id, db.productIngredientLinks.ingredientId));

  $$ProductIngredientLinksTableProcessedTableManager
      get productIngredientLinksRefs {
    final manager = $$ProductIngredientLinksTableTableManager(
            $_db, $_db.productIngredientLinks)
        .filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_productIngredientLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
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

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isGlobal => $composableBuilder(
      column: $table.isGlobal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> productIngredientLinksRefs(
      Expression<bool> Function($$ProductIngredientLinksTableFilterComposer f)
          f) {
    final $$ProductIngredientLinksTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productIngredientLinks,
            getReferencedColumn: (t) => t.ingredientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductIngredientLinksTableFilterComposer(
                  $db: $db,
                  $table: $db.productIngredientLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
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

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isGlobal => $composableBuilder(
      column: $table.isGlobal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
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

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isGlobal =>
      $composableBuilder(column: $table.isGlobal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> productIngredientLinksRefs<T extends Object>(
      Expression<T> Function($$ProductIngredientLinksTableAnnotationComposer a)
          f) {
    final $$ProductIngredientLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productIngredientLinks,
            getReferencedColumn: (t) => t.ingredientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductIngredientLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productIngredientLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$IngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function({bool productIngredientLinksRefs})> {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> isGlobal = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            name: name,
            price: price,
            category: category,
            isGlobal: isGlobal,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double price,
            Value<String?> category = const Value.absent(),
            Value<bool> isGlobal = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              IngredientsCompanion.insert(
            id: id,
            name: name,
            price: price,
            category: category,
            isGlobal: isGlobal,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IngredientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productIngredientLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productIngredientLinksRefs) db.productIngredientLinks
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productIngredientLinksRefs)
                    await $_getPrefetchedData<Ingredient, $IngredientsTable,
                            ProductIngredientLink>(
                        currentTable: table,
                        referencedTable: $$IngredientsTableReferences
                            ._productIngredientLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientsTableReferences(db, table, p0)
                                .productIngredientLinksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$IngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function({bool productIngredientLinksRefs})>;
typedef $$AdminsTableCreateCompanionBuilder = AdminsCompanion Function({
  required String id,
  required String email,
  Value<String> role,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AdminsTableUpdateCompanionBuilder = AdminsCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> role,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$AdminsTableFilterComposer
    extends Composer<_$AppDatabase, $AdminsTable> {
  $$AdminsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AdminsTableOrderingComposer
    extends Composer<_$AppDatabase, $AdminsTable> {
  $$AdminsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AdminsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdminsTable> {
  $$AdminsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AdminsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AdminsTable,
    Admin,
    $$AdminsTableFilterComposer,
    $$AdminsTableOrderingComposer,
    $$AdminsTableAnnotationComposer,
    $$AdminsTableCreateCompanionBuilder,
    $$AdminsTableUpdateCompanionBuilder,
    (Admin, BaseReferences<_$AppDatabase, $AdminsTable, Admin>),
    Admin,
    PrefetchHooks Function()> {
  $$AdminsTableTableManager(_$AppDatabase db, $AdminsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdminsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdminsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdminsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AdminsCompanion(
            id: id,
            email: email,
            role: role,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String email,
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AdminsCompanion.insert(
            id: id,
            email: email,
            role: role,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AdminsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AdminsTable,
    Admin,
    $$AdminsTableFilterComposer,
    $$AdminsTableOrderingComposer,
    $$AdminsTableAnnotationComposer,
    $$AdminsTableCreateCompanionBuilder,
    $$AdminsTableUpdateCompanionBuilder,
    (Admin, BaseReferences<_$AppDatabase, $AdminsTable, Admin>),
    Admin,
    PrefetchHooks Function()>;
typedef $$AnnouncementsTableCreateCompanionBuilder = AnnouncementsCompanion
    Function({
  Value<int> id,
  required String title,
  Value<String?> announcementText,
  Value<String?> description,
  Value<String?> imageUrl,
  Value<String?> conclusion,
  Value<bool> isActive,
  Value<String> type,
  required DateTime createdAt,
});
typedef $$AnnouncementsTableUpdateCompanionBuilder = AnnouncementsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String?> announcementText,
  Value<String?> description,
  Value<String?> imageUrl,
  Value<String?> conclusion,
  Value<bool> isActive,
  Value<String> type,
  Value<DateTime> createdAt,
});

class $$AnnouncementsTableFilterComposer
    extends Composer<_$AppDatabase, $AnnouncementsTable> {
  $$AnnouncementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get announcementText => $composableBuilder(
      column: $table.announcementText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conclusion => $composableBuilder(
      column: $table.conclusion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AnnouncementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnouncementsTable> {
  $$AnnouncementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get announcementText => $composableBuilder(
      column: $table.announcementText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conclusion => $composableBuilder(
      column: $table.conclusion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AnnouncementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnouncementsTable> {
  $$AnnouncementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get announcementText => $composableBuilder(
      column: $table.announcementText, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get conclusion => $composableBuilder(
      column: $table.conclusion, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AnnouncementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnnouncementsTable,
    Announcement,
    $$AnnouncementsTableFilterComposer,
    $$AnnouncementsTableOrderingComposer,
    $$AnnouncementsTableAnnotationComposer,
    $$AnnouncementsTableCreateCompanionBuilder,
    $$AnnouncementsTableUpdateCompanionBuilder,
    (
      Announcement,
      BaseReferences<_$AppDatabase, $AnnouncementsTable, Announcement>
    ),
    Announcement,
    PrefetchHooks Function()> {
  $$AnnouncementsTableTableManager(_$AppDatabase db, $AnnouncementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnouncementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnouncementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnouncementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> announcementText = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> conclusion = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AnnouncementsCompanion(
            id: id,
            title: title,
            announcementText: announcementText,
            description: description,
            imageUrl: imageUrl,
            conclusion: conclusion,
            isActive: isActive,
            type: type,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> announcementText = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> conclusion = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> type = const Value.absent(),
            required DateTime createdAt,
          }) =>
              AnnouncementsCompanion.insert(
            id: id,
            title: title,
            announcementText: announcementText,
            description: description,
            imageUrl: imageUrl,
            conclusion: conclusion,
            isActive: isActive,
            type: type,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnnouncementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnnouncementsTable,
    Announcement,
    $$AnnouncementsTableFilterComposer,
    $$AnnouncementsTableOrderingComposer,
    $$AnnouncementsTableAnnotationComposer,
    $$AnnouncementsTableCreateCompanionBuilder,
    $$AnnouncementsTableUpdateCompanionBuilder,
    (
      Announcement,
      BaseReferences<_$AppDatabase, $AnnouncementsTable, Announcement>
    ),
    Announcement,
    PrefetchHooks Function()>;
typedef $$CompanyInfoTableCreateCompanionBuilder = CompanyInfoCompanion
    Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> presentation,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> facebookUrl,
  Value<String?> instagramUrl,
  Value<String?> xUrl,
  Value<String?> whatsappPhone,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> ordersEnabled,
  Value<String?> closureMessageType,
  Value<DateTime?> closureStartDate,
  Value<DateTime?> closureEndDate,
  Value<String?> closureCustomMessage,
  Value<String?> logoUrl,
  Value<double?> tvaRate,
  Value<String?> googleUrl,
  Value<String?> pagesJaunesUrl,
});
typedef $$CompanyInfoTableUpdateCompanionBuilder = CompanyInfoCompanion
    Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> presentation,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> facebookUrl,
  Value<String?> instagramUrl,
  Value<String?> xUrl,
  Value<String?> whatsappPhone,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> ordersEnabled,
  Value<String?> closureMessageType,
  Value<DateTime?> closureStartDate,
  Value<DateTime?> closureEndDate,
  Value<String?> closureCustomMessage,
  Value<String?> logoUrl,
  Value<double?> tvaRate,
  Value<String?> googleUrl,
  Value<String?> pagesJaunesUrl,
});

class $$CompanyInfoTableFilterComposer
    extends Composer<_$AppDatabase, $CompanyInfoTable> {
  $$CompanyInfoTableFilterComposer({
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

  ColumnFilters<String> get presentation => $composableBuilder(
      column: $table.presentation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get facebookUrl => $composableBuilder(
      column: $table.facebookUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instagramUrl => $composableBuilder(
      column: $table.instagramUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get xUrl => $composableBuilder(
      column: $table.xUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsappPhone => $composableBuilder(
      column: $table.whatsappPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ordersEnabled => $composableBuilder(
      column: $table.ordersEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closureMessageType => $composableBuilder(
      column: $table.closureMessageType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closureStartDate => $composableBuilder(
      column: $table.closureStartDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closureEndDate => $composableBuilder(
      column: $table.closureEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closureCustomMessage => $composableBuilder(
      column: $table.closureCustomMessage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tvaRate => $composableBuilder(
      column: $table.tvaRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get googleUrl => $composableBuilder(
      column: $table.googleUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pagesJaunesUrl => $composableBuilder(
      column: $table.pagesJaunesUrl,
      builder: (column) => ColumnFilters(column));
}

class $$CompanyInfoTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanyInfoTable> {
  $$CompanyInfoTableOrderingComposer({
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

  ColumnOrderings<String> get presentation => $composableBuilder(
      column: $table.presentation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get facebookUrl => $composableBuilder(
      column: $table.facebookUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instagramUrl => $composableBuilder(
      column: $table.instagramUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get xUrl => $composableBuilder(
      column: $table.xUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsappPhone => $composableBuilder(
      column: $table.whatsappPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ordersEnabled => $composableBuilder(
      column: $table.ordersEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closureMessageType => $composableBuilder(
      column: $table.closureMessageType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closureStartDate => $composableBuilder(
      column: $table.closureStartDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closureEndDate => $composableBuilder(
      column: $table.closureEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closureCustomMessage => $composableBuilder(
      column: $table.closureCustomMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tvaRate => $composableBuilder(
      column: $table.tvaRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get googleUrl => $composableBuilder(
      column: $table.googleUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pagesJaunesUrl => $composableBuilder(
      column: $table.pagesJaunesUrl,
      builder: (column) => ColumnOrderings(column));
}

class $$CompanyInfoTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanyInfoTable> {
  $$CompanyInfoTableAnnotationComposer({
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

  GeneratedColumn<String> get presentation => $composableBuilder(
      column: $table.presentation, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get facebookUrl => $composableBuilder(
      column: $table.facebookUrl, builder: (column) => column);

  GeneratedColumn<String> get instagramUrl => $composableBuilder(
      column: $table.instagramUrl, builder: (column) => column);

  GeneratedColumn<String> get xUrl =>
      $composableBuilder(column: $table.xUrl, builder: (column) => column);

  GeneratedColumn<String> get whatsappPhone => $composableBuilder(
      column: $table.whatsappPhone, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get ordersEnabled => $composableBuilder(
      column: $table.ordersEnabled, builder: (column) => column);

  GeneratedColumn<String> get closureMessageType => $composableBuilder(
      column: $table.closureMessageType, builder: (column) => column);

  GeneratedColumn<DateTime> get closureStartDate => $composableBuilder(
      column: $table.closureStartDate, builder: (column) => column);

  GeneratedColumn<DateTime> get closureEndDate => $composableBuilder(
      column: $table.closureEndDate, builder: (column) => column);

  GeneratedColumn<String> get closureCustomMessage => $composableBuilder(
      column: $table.closureCustomMessage, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<double> get tvaRate =>
      $composableBuilder(column: $table.tvaRate, builder: (column) => column);

  GeneratedColumn<String> get googleUrl =>
      $composableBuilder(column: $table.googleUrl, builder: (column) => column);

  GeneratedColumn<String> get pagesJaunesUrl => $composableBuilder(
      column: $table.pagesJaunesUrl, builder: (column) => column);
}

class $$CompanyInfoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompanyInfoTable,
    CompanyInfoData,
    $$CompanyInfoTableFilterComposer,
    $$CompanyInfoTableOrderingComposer,
    $$CompanyInfoTableAnnotationComposer,
    $$CompanyInfoTableCreateCompanionBuilder,
    $$CompanyInfoTableUpdateCompanionBuilder,
    (
      CompanyInfoData,
      BaseReferences<_$AppDatabase, $CompanyInfoTable, CompanyInfoData>
    ),
    CompanyInfoData,
    PrefetchHooks Function()> {
  $$CompanyInfoTableTableManager(_$AppDatabase db, $CompanyInfoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanyInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanyInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompanyInfoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> presentation = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> facebookUrl = const Value.absent(),
            Value<String?> instagramUrl = const Value.absent(),
            Value<String?> xUrl = const Value.absent(),
            Value<String?> whatsappPhone = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> ordersEnabled = const Value.absent(),
            Value<String?> closureMessageType = const Value.absent(),
            Value<DateTime?> closureStartDate = const Value.absent(),
            Value<DateTime?> closureEndDate = const Value.absent(),
            Value<String?> closureCustomMessage = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<double?> tvaRate = const Value.absent(),
            Value<String?> googleUrl = const Value.absent(),
            Value<String?> pagesJaunesUrl = const Value.absent(),
          }) =>
              CompanyInfoCompanion(
            id: id,
            name: name,
            presentation: presentation,
            address: address,
            phone: phone,
            email: email,
            facebookUrl: facebookUrl,
            instagramUrl: instagramUrl,
            xUrl: xUrl,
            whatsappPhone: whatsappPhone,
            latitude: latitude,
            longitude: longitude,
            ordersEnabled: ordersEnabled,
            closureMessageType: closureMessageType,
            closureStartDate: closureStartDate,
            closureEndDate: closureEndDate,
            closureCustomMessage: closureCustomMessage,
            logoUrl: logoUrl,
            tvaRate: tvaRate,
            googleUrl: googleUrl,
            pagesJaunesUrl: pagesJaunesUrl,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> presentation = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> facebookUrl = const Value.absent(),
            Value<String?> instagramUrl = const Value.absent(),
            Value<String?> xUrl = const Value.absent(),
            Value<String?> whatsappPhone = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> ordersEnabled = const Value.absent(),
            Value<String?> closureMessageType = const Value.absent(),
            Value<DateTime?> closureStartDate = const Value.absent(),
            Value<DateTime?> closureEndDate = const Value.absent(),
            Value<String?> closureCustomMessage = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<double?> tvaRate = const Value.absent(),
            Value<String?> googleUrl = const Value.absent(),
            Value<String?> pagesJaunesUrl = const Value.absent(),
          }) =>
              CompanyInfoCompanion.insert(
            id: id,
            name: name,
            presentation: presentation,
            address: address,
            phone: phone,
            email: email,
            facebookUrl: facebookUrl,
            instagramUrl: instagramUrl,
            xUrl: xUrl,
            whatsappPhone: whatsappPhone,
            latitude: latitude,
            longitude: longitude,
            ordersEnabled: ordersEnabled,
            closureMessageType: closureMessageType,
            closureStartDate: closureStartDate,
            closureEndDate: closureEndDate,
            closureCustomMessage: closureCustomMessage,
            logoUrl: logoUrl,
            tvaRate: tvaRate,
            googleUrl: googleUrl,
            pagesJaunesUrl: pagesJaunesUrl,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompanyInfoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CompanyInfoTable,
    CompanyInfoData,
    $$CompanyInfoTableFilterComposer,
    $$CompanyInfoTableOrderingComposer,
    $$CompanyInfoTableAnnotationComposer,
    $$CompanyInfoTableCreateCompanionBuilder,
    $$CompanyInfoTableUpdateCompanionBuilder,
    (
      CompanyInfoData,
      BaseReferences<_$AppDatabase, $CompanyInfoTable, CompanyInfoData>
    ),
    CompanyInfoData,
    PrefetchHooks Function()>;
typedef $$ProductIngredientLinksTableCreateCompanionBuilder
    = ProductIngredientLinksCompanion Function({
  required int productId,
  required int ingredientId,
  Value<bool> isBaseIngredient,
  Value<int> rowid,
});
typedef $$ProductIngredientLinksTableUpdateCompanionBuilder
    = ProductIngredientLinksCompanion Function({
  Value<int> productId,
  Value<int> ingredientId,
  Value<bool> isBaseIngredient,
  Value<int> rowid,
});

final class $$ProductIngredientLinksTableReferences extends BaseReferences<
    _$AppDatabase, $ProductIngredientLinksTable, ProductIngredientLink> {
  $$ProductIngredientLinksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias($_aliasNameGenerator(
          db.productIngredientLinks.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias($_aliasNameGenerator(
          db.productIngredientLinks.ingredientId, db.ingredients.id));

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductIngredientLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ProductIngredientLinksTable> {
  $$ProductIngredientLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isBaseIngredient => $composableBuilder(
      column: $table.isBaseIngredient,
      builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductIngredientLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductIngredientLinksTable> {
  $$ProductIngredientLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isBaseIngredient => $composableBuilder(
      column: $table.isBaseIngredient,
      builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableOrderingComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductIngredientLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductIngredientLinksTable> {
  $$ProductIngredientLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isBaseIngredient => $composableBuilder(
      column: $table.isBaseIngredient, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductIngredientLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductIngredientLinksTable,
    ProductIngredientLink,
    $$ProductIngredientLinksTableFilterComposer,
    $$ProductIngredientLinksTableOrderingComposer,
    $$ProductIngredientLinksTableAnnotationComposer,
    $$ProductIngredientLinksTableCreateCompanionBuilder,
    $$ProductIngredientLinksTableUpdateCompanionBuilder,
    (ProductIngredientLink, $$ProductIngredientLinksTableReferences),
    ProductIngredientLink,
    PrefetchHooks Function({bool productId, bool ingredientId})> {
  $$ProductIngredientLinksTableTableManager(
      _$AppDatabase db, $ProductIngredientLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductIngredientLinksTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductIngredientLinksTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductIngredientLinksTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> productId = const Value.absent(),
            Value<int> ingredientId = const Value.absent(),
            Value<bool> isBaseIngredient = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductIngredientLinksCompanion(
            productId: productId,
            ingredientId: ingredientId,
            isBaseIngredient: isBaseIngredient,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int productId,
            required int ingredientId,
            Value<bool> isBaseIngredient = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductIngredientLinksCompanion.insert(
            productId: productId,
            ingredientId: ingredientId,
            isBaseIngredient: isBaseIngredient,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductIngredientLinksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable: $$ProductIngredientLinksTableReferences
                        ._productIdTable(db),
                    referencedColumn: $$ProductIngredientLinksTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }
                if (ingredientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredientId,
                    referencedTable: $$ProductIngredientLinksTableReferences
                        ._ingredientIdTable(db),
                    referencedColumn: $$ProductIngredientLinksTableReferences
                        ._ingredientIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductIngredientLinksTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ProductIngredientLinksTable,
        ProductIngredientLink,
        $$ProductIngredientLinksTableFilterComposer,
        $$ProductIngredientLinksTableOrderingComposer,
        $$ProductIngredientLinksTableAnnotationComposer,
        $$ProductIngredientLinksTableCreateCompanionBuilder,
        $$ProductIngredientLinksTableUpdateCompanionBuilder,
        (ProductIngredientLink, $$ProductIngredientLinksTableReferences),
        ProductIngredientLink,
        PrefetchHooks Function({bool productId, bool ingredientId})>;
typedef $$SavedCartItemsTableCreateCompanionBuilder = SavedCartItemsCompanion
    Function({
  required String uniqueId,
  required int productId,
  required int quantity,
  required String selectedIngredients,
  Value<String> removedIngredients,
  Value<int> rowid,
});
typedef $$SavedCartItemsTableUpdateCompanionBuilder = SavedCartItemsCompanion
    Function({
  Value<String> uniqueId,
  Value<int> productId,
  Value<int> quantity,
  Value<String> selectedIngredients,
  Value<String> removedIngredients,
  Value<int> rowid,
});

class $$SavedCartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedCartItemsTable> {
  $$SavedCartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uniqueId => $composableBuilder(
      column: $table.uniqueId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedIngredients => $composableBuilder(
      column: $table.selectedIngredients,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get removedIngredients => $composableBuilder(
      column: $table.removedIngredients,
      builder: (column) => ColumnFilters(column));
}

class $$SavedCartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedCartItemsTable> {
  $$SavedCartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uniqueId => $composableBuilder(
      column: $table.uniqueId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedIngredients => $composableBuilder(
      column: $table.selectedIngredients,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get removedIngredients => $composableBuilder(
      column: $table.removedIngredients,
      builder: (column) => ColumnOrderings(column));
}

class $$SavedCartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedCartItemsTable> {
  $$SavedCartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uniqueId =>
      $composableBuilder(column: $table.uniqueId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get selectedIngredients => $composableBuilder(
      column: $table.selectedIngredients, builder: (column) => column);

  GeneratedColumn<String> get removedIngredients => $composableBuilder(
      column: $table.removedIngredients, builder: (column) => column);
}

class $$SavedCartItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedCartItemsTable,
    SavedCartItem,
    $$SavedCartItemsTableFilterComposer,
    $$SavedCartItemsTableOrderingComposer,
    $$SavedCartItemsTableAnnotationComposer,
    $$SavedCartItemsTableCreateCompanionBuilder,
    $$SavedCartItemsTableUpdateCompanionBuilder,
    (
      SavedCartItem,
      BaseReferences<_$AppDatabase, $SavedCartItemsTable, SavedCartItem>
    ),
    SavedCartItem,
    PrefetchHooks Function()> {
  $$SavedCartItemsTableTableManager(
      _$AppDatabase db, $SavedCartItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedCartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedCartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedCartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> uniqueId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> selectedIngredients = const Value.absent(),
            Value<String> removedIngredients = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedCartItemsCompanion(
            uniqueId: uniqueId,
            productId: productId,
            quantity: quantity,
            selectedIngredients: selectedIngredients,
            removedIngredients: removedIngredients,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String uniqueId,
            required int productId,
            required int quantity,
            required String selectedIngredients,
            Value<String> removedIngredients = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedCartItemsCompanion.insert(
            uniqueId: uniqueId,
            productId: productId,
            quantity: quantity,
            selectedIngredients: selectedIngredients,
            removedIngredients: removedIngredients,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedCartItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedCartItemsTable,
    SavedCartItem,
    $$SavedCartItemsTableFilterComposer,
    $$SavedCartItemsTableOrderingComposer,
    $$SavedCartItemsTableAnnotationComposer,
    $$SavedCartItemsTableCreateCompanionBuilder,
    $$SavedCartItemsTableUpdateCompanionBuilder,
    (
      SavedCartItem,
      BaseReferences<_$AppDatabase, $SavedCartItemsTable, SavedCartItem>
    ),
    SavedCartItem,
    PrefetchHooks Function()>;
typedef $$OrderStatusHistoriesTableCreateCompanionBuilder
    = OrderStatusHistoriesCompanion Function({
  Value<int> id,
  required int orderId,
  required String status,
  required DateTime createdAt,
});
typedef $$OrderStatusHistoriesTableUpdateCompanionBuilder
    = OrderStatusHistoriesCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<String> status,
  Value<DateTime> createdAt,
});

final class $$OrderStatusHistoriesTableReferences extends BaseReferences<
    _$AppDatabase, $OrderStatusHistoriesTable, OrderStatusHistory> {
  $$OrderStatusHistoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
      $_aliasNameGenerator(db.orderStatusHistories.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderStatusHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $OrderStatusHistoriesTable> {
  $$OrderStatusHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderStatusHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderStatusHistoriesTable> {
  $$OrderStatusHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderStatusHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderStatusHistoriesTable> {
  $$OrderStatusHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderStatusHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderStatusHistoriesTable,
    OrderStatusHistory,
    $$OrderStatusHistoriesTableFilterComposer,
    $$OrderStatusHistoriesTableOrderingComposer,
    $$OrderStatusHistoriesTableAnnotationComposer,
    $$OrderStatusHistoriesTableCreateCompanionBuilder,
    $$OrderStatusHistoriesTableUpdateCompanionBuilder,
    (OrderStatusHistory, $$OrderStatusHistoriesTableReferences),
    OrderStatusHistory,
    PrefetchHooks Function({bool orderId})> {
  $$OrderStatusHistoriesTableTableManager(
      _$AppDatabase db, $OrderStatusHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderStatusHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderStatusHistoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderStatusHistoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OrderStatusHistoriesCompanion(
            id: id,
            orderId: orderId,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required String status,
            required DateTime createdAt,
          }) =>
              OrderStatusHistoriesCompanion.insert(
            id: id,
            orderId: orderId,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderStatusHistoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderStatusHistoriesTableReferences._orderIdTable(db),
                    referencedColumn: $$OrderStatusHistoriesTableReferences
                        ._orderIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderStatusHistoriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $OrderStatusHistoriesTable,
        OrderStatusHistory,
        $$OrderStatusHistoriesTableFilterComposer,
        $$OrderStatusHistoriesTableOrderingComposer,
        $$OrderStatusHistoriesTableAnnotationComposer,
        $$OrderStatusHistoriesTableCreateCompanionBuilder,
        $$OrderStatusHistoriesTableUpdateCompanionBuilder,
        (OrderStatusHistory, $$OrderStatusHistoriesTableReferences),
        OrderStatusHistory,
        PrefetchHooks Function({bool orderId})>;
typedef $$LoyaltySettingsTableCreateCompanionBuilder = LoyaltySettingsCompanion
    Function({
  Value<int> id,
  Value<bool> isEnabled,
  Value<String> mode,
  Value<int> threshold,
  Value<double> discountPercentage,
});
typedef $$LoyaltySettingsTableUpdateCompanionBuilder = LoyaltySettingsCompanion
    Function({
  Value<int> id,
  Value<bool> isEnabled,
  Value<String> mode,
  Value<int> threshold,
  Value<double> discountPercentage,
});

class $$LoyaltySettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LoyaltySettingsTable> {
  $$LoyaltySettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnFilters(column));
}

class $$LoyaltySettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoyaltySettingsTable> {
  $$LoyaltySettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnOrderings(column));
}

class $$LoyaltySettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoyaltySettingsTable> {
  $$LoyaltySettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage, builder: (column) => column);
}

class $$LoyaltySettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoyaltySettingsTable,
    LoyaltySetting,
    $$LoyaltySettingsTableFilterComposer,
    $$LoyaltySettingsTableOrderingComposer,
    $$LoyaltySettingsTableAnnotationComposer,
    $$LoyaltySettingsTableCreateCompanionBuilder,
    $$LoyaltySettingsTableUpdateCompanionBuilder,
    (
      LoyaltySetting,
      BaseReferences<_$AppDatabase, $LoyaltySettingsTable, LoyaltySetting>
    ),
    LoyaltySetting,
    PrefetchHooks Function()> {
  $$LoyaltySettingsTableTableManager(
      _$AppDatabase db, $LoyaltySettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoyaltySettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoyaltySettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoyaltySettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<int> threshold = const Value.absent(),
            Value<double> discountPercentage = const Value.absent(),
          }) =>
              LoyaltySettingsCompanion(
            id: id,
            isEnabled: isEnabled,
            mode: mode,
            threshold: threshold,
            discountPercentage: discountPercentage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<int> threshold = const Value.absent(),
            Value<double> discountPercentage = const Value.absent(),
          }) =>
              LoyaltySettingsCompanion.insert(
            id: id,
            isEnabled: isEnabled,
            mode: mode,
            threshold: threshold,
            discountPercentage: discountPercentage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LoyaltySettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoyaltySettingsTable,
    LoyaltySetting,
    $$LoyaltySettingsTableFilterComposer,
    $$LoyaltySettingsTableOrderingComposer,
    $$LoyaltySettingsTableAnnotationComposer,
    $$LoyaltySettingsTableCreateCompanionBuilder,
    $$LoyaltySettingsTableUpdateCompanionBuilder,
    (
      LoyaltySetting,
      BaseReferences<_$AppDatabase, $LoyaltySettingsTable, LoyaltySetting>
    ),
    LoyaltySetting,
    PrefetchHooks Function()>;
typedef $$UserLoyaltiesTableCreateCompanionBuilder = UserLoyaltiesCompanion
    Function({
  required String userId,
  Value<int> points,
  Value<int> pizzaCount,
  Value<int> rowid,
});
typedef $$UserLoyaltiesTableUpdateCompanionBuilder = UserLoyaltiesCompanion
    Function({
  Value<String> userId,
  Value<int> points,
  Value<int> pizzaCount,
  Value<int> rowid,
});

final class $$UserLoyaltiesTableReferences
    extends BaseReferences<_$AppDatabase, $UserLoyaltiesTable, UserLoyalty> {
  $$UserLoyaltiesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.userLoyalties.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UserLoyaltiesTableFilterComposer
    extends Composer<_$AppDatabase, $UserLoyaltiesTable> {
  $$UserLoyaltiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pizzaCount => $composableBuilder(
      column: $table.pizzaCount, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserLoyaltiesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserLoyaltiesTable> {
  $$UserLoyaltiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pizzaCount => $composableBuilder(
      column: $table.pizzaCount, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserLoyaltiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserLoyaltiesTable> {
  $$UserLoyaltiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get pizzaCount => $composableBuilder(
      column: $table.pizzaCount, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserLoyaltiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserLoyaltiesTable,
    UserLoyalty,
    $$UserLoyaltiesTableFilterComposer,
    $$UserLoyaltiesTableOrderingComposer,
    $$UserLoyaltiesTableAnnotationComposer,
    $$UserLoyaltiesTableCreateCompanionBuilder,
    $$UserLoyaltiesTableUpdateCompanionBuilder,
    (UserLoyalty, $$UserLoyaltiesTableReferences),
    UserLoyalty,
    PrefetchHooks Function({bool userId})> {
  $$UserLoyaltiesTableTableManager(_$AppDatabase db, $UserLoyaltiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserLoyaltiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserLoyaltiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserLoyaltiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<int> pizzaCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserLoyaltiesCompanion(
            userId: userId,
            points: points,
            pizzaCount: pizzaCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            Value<int> points = const Value.absent(),
            Value<int> pizzaCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserLoyaltiesCompanion.insert(
            userId: userId,
            points: points,
            pizzaCount: pizzaCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserLoyaltiesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$UserLoyaltiesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$UserLoyaltiesTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UserLoyaltiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserLoyaltiesTable,
    UserLoyalty,
    $$UserLoyaltiesTableFilterComposer,
    $$UserLoyaltiesTableOrderingComposer,
    $$UserLoyaltiesTableAnnotationComposer,
    $$UserLoyaltiesTableCreateCompanionBuilder,
    $$UserLoyaltiesTableUpdateCompanionBuilder,
    (UserLoyalty, $$UserLoyaltiesTableReferences),
    UserLoyalty,
    PrefetchHooks Function({bool userId})>;
typedef $$ProductOptionsTableCreateCompanionBuilder = ProductOptionsCompanion
    Function({
  Value<int> id,
  Value<int?> productId,
  required String name,
  required double price,
  Value<bool> isGlobal,
  Value<String?> category,
});
typedef $$ProductOptionsTableUpdateCompanionBuilder = ProductOptionsCompanion
    Function({
  Value<int> id,
  Value<int?> productId,
  Value<String> name,
  Value<double> price,
  Value<bool> isGlobal,
  Value<String?> category,
});

final class $$ProductOptionsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductOptionsTable, ProductOption> {
  $$ProductOptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.productOptions.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductOptionLinksTable, List<ProductOptionLink>>
      _productOptionLinksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productOptionLinks,
              aliasName: $_aliasNameGenerator(
                  db.productOptions.id, db.productOptionLinks.optionId));

  $$ProductOptionLinksTableProcessedTableManager get productOptionLinksRefs {
    final manager =
        $$ProductOptionLinksTableTableManager($_db, $_db.productOptionLinks)
            .filter((f) => f.optionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_productOptionLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductOptionsTable> {
  $$ProductOptionsTableFilterComposer({
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

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isGlobal => $composableBuilder(
      column: $table.isGlobal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productOptionLinksRefs(
      Expression<bool> Function($$ProductOptionLinksTableFilterComposer f) f) {
    final $$ProductOptionLinksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productOptionLinks,
        getReferencedColumn: (t) => t.optionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOptionLinksTableFilterComposer(
              $db: $db,
              $table: $db.productOptionLinks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductOptionsTable> {
  $$ProductOptionsTableOrderingComposer({
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

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isGlobal => $composableBuilder(
      column: $table.isGlobal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductOptionsTable> {
  $$ProductOptionsTableAnnotationComposer({
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

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<bool> get isGlobal =>
      $composableBuilder(column: $table.isGlobal, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productOptionLinksRefs<T extends Object>(
      Expression<T> Function($$ProductOptionLinksTableAnnotationComposer a) f) {
    final $$ProductOptionLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productOptionLinks,
            getReferencedColumn: (t) => t.optionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductOptionLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productOptionLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProductOptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductOptionsTable,
    ProductOption,
    $$ProductOptionsTableFilterComposer,
    $$ProductOptionsTableOrderingComposer,
    $$ProductOptionsTableAnnotationComposer,
    $$ProductOptionsTableCreateCompanionBuilder,
    $$ProductOptionsTableUpdateCompanionBuilder,
    (ProductOption, $$ProductOptionsTableReferences),
    ProductOption,
    PrefetchHooks Function({bool productId, bool productOptionLinksRefs})> {
  $$ProductOptionsTableTableManager(
      _$AppDatabase db, $ProductOptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductOptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> productId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<bool> isGlobal = const Value.absent(),
            Value<String?> category = const Value.absent(),
          }) =>
              ProductOptionsCompanion(
            id: id,
            productId: productId,
            name: name,
            price: price,
            isGlobal: isGlobal,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> productId = const Value.absent(),
            required String name,
            required double price,
            Value<bool> isGlobal = const Value.absent(),
            Value<String?> category = const Value.absent(),
          }) =>
              ProductOptionsCompanion.insert(
            id: id,
            productId: productId,
            name: name,
            price: price,
            isGlobal: isGlobal,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductOptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {productId = false, productOptionLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productOptionLinksRefs) db.productOptionLinks
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductOptionsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$ProductOptionsTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productOptionLinksRefs)
                    await $_getPrefetchedData<ProductOption,
                            $ProductOptionsTable, ProductOptionLink>(
                        currentTable: table,
                        referencedTable: $$ProductOptionsTableReferences
                            ._productOptionLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductOptionsTableReferences(db, table, p0)
                                .productOptionLinksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.optionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductOptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductOptionsTable,
    ProductOption,
    $$ProductOptionsTableFilterComposer,
    $$ProductOptionsTableOrderingComposer,
    $$ProductOptionsTableAnnotationComposer,
    $$ProductOptionsTableCreateCompanionBuilder,
    $$ProductOptionsTableUpdateCompanionBuilder,
    (ProductOption, $$ProductOptionsTableReferences),
    ProductOption,
    PrefetchHooks Function({bool productId, bool productOptionLinksRefs})>;
typedef $$ProductOptionLinksTableCreateCompanionBuilder
    = ProductOptionLinksCompanion Function({
  required int productId,
  required int optionId,
  Value<int> rowid,
});
typedef $$ProductOptionLinksTableUpdateCompanionBuilder
    = ProductOptionLinksCompanion Function({
  Value<int> productId,
  Value<int> optionId,
  Value<int> rowid,
});

final class $$ProductOptionLinksTableReferences extends BaseReferences<
    _$AppDatabase, $ProductOptionLinksTable, ProductOptionLink> {
  $$ProductOptionLinksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias($_aliasNameGenerator(
          db.productOptionLinks.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductOptionsTable _optionIdTable(_$AppDatabase db) =>
      db.productOptions.createAlias($_aliasNameGenerator(
          db.productOptionLinks.optionId, db.productOptions.id));

  $$ProductOptionsTableProcessedTableManager get optionId {
    final $_column = $_itemColumn<int>('option_id')!;

    final manager = $$ProductOptionsTableTableManager($_db, $_db.productOptions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_optionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductOptionLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ProductOptionLinksTable> {
  $$ProductOptionLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductOptionsTableFilterComposer get optionId {
    final $$ProductOptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.optionId,
        referencedTable: $db.productOptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOptionsTableFilterComposer(
              $db: $db,
              $table: $db.productOptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductOptionLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductOptionLinksTable> {
  $$ProductOptionLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductOptionsTableOrderingComposer get optionId {
    final $$ProductOptionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.optionId,
        referencedTable: $db.productOptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOptionsTableOrderingComposer(
              $db: $db,
              $table: $db.productOptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductOptionLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductOptionLinksTable> {
  $$ProductOptionLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductOptionsTableAnnotationComposer get optionId {
    final $$ProductOptionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.optionId,
        referencedTable: $db.productOptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOptionsTableAnnotationComposer(
              $db: $db,
              $table: $db.productOptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductOptionLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductOptionLinksTable,
    ProductOptionLink,
    $$ProductOptionLinksTableFilterComposer,
    $$ProductOptionLinksTableOrderingComposer,
    $$ProductOptionLinksTableAnnotationComposer,
    $$ProductOptionLinksTableCreateCompanionBuilder,
    $$ProductOptionLinksTableUpdateCompanionBuilder,
    (ProductOptionLink, $$ProductOptionLinksTableReferences),
    ProductOptionLink,
    PrefetchHooks Function({bool productId, bool optionId})> {
  $$ProductOptionLinksTableTableManager(
      _$AppDatabase db, $ProductOptionLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductOptionLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductOptionLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductOptionLinksTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> productId = const Value.absent(),
            Value<int> optionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductOptionLinksCompanion(
            productId: productId,
            optionId: optionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int productId,
            required int optionId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductOptionLinksCompanion.insert(
            productId: productId,
            optionId: optionId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductOptionLinksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false, optionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductOptionLinksTableReferences._productIdTable(db),
                    referencedColumn: $$ProductOptionLinksTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }
                if (optionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.optionId,
                    referencedTable:
                        $$ProductOptionLinksTableReferences._optionIdTable(db),
                    referencedColumn: $$ProductOptionLinksTableReferences
                        ._optionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductOptionLinksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductOptionLinksTable,
    ProductOptionLink,
    $$ProductOptionLinksTableFilterComposer,
    $$ProductOptionLinksTableOrderingComposer,
    $$ProductOptionLinksTableAnnotationComposer,
    $$ProductOptionLinksTableCreateCompanionBuilder,
    $$ProductOptionLinksTableUpdateCompanionBuilder,
    (ProductOptionLink, $$ProductOptionLinksTableReferences),
    ProductOptionLink,
    PrefetchHooks Function({bool productId, bool optionId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$ReviewsTableTableManager get reviews =>
      $$ReviewsTableTableManager(_db, _db.reviews);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$AdminsTableTableManager get admins =>
      $$AdminsTableTableManager(_db, _db.admins);
  $$AnnouncementsTableTableManager get announcements =>
      $$AnnouncementsTableTableManager(_db, _db.announcements);
  $$CompanyInfoTableTableManager get companyInfo =>
      $$CompanyInfoTableTableManager(_db, _db.companyInfo);
  $$ProductIngredientLinksTableTableManager get productIngredientLinks =>
      $$ProductIngredientLinksTableTableManager(
          _db, _db.productIngredientLinks);
  $$SavedCartItemsTableTableManager get savedCartItems =>
      $$SavedCartItemsTableTableManager(_db, _db.savedCartItems);
  $$OrderStatusHistoriesTableTableManager get orderStatusHistories =>
      $$OrderStatusHistoriesTableTableManager(_db, _db.orderStatusHistories);
  $$LoyaltySettingsTableTableManager get loyaltySettings =>
      $$LoyaltySettingsTableTableManager(_db, _db.loyaltySettings);
  $$UserLoyaltiesTableTableManager get userLoyalties =>
      $$UserLoyaltiesTableTableManager(_db, _db.userLoyalties);
  $$ProductOptionsTableTableManager get productOptions =>
      $$ProductOptionsTableTableManager(_db, _db.productOptions);
  $$ProductOptionLinksTableTableManager get productOptionLinks =>
      $$ProductOptionLinksTableTableManager(_db, _db.productOptionLinks);
}

mixin _$ProductDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductsTable get products => attachedDatabase.products;
}
