import 'package:floor/floor.dart';

@Entity(tableName: 'products')
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'name')
  final String? name;

  final String? description;

  @ColumnInfo(name: 'price')
  final double? price;

  final String? image;

  final String? category;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.category,
  });
}
