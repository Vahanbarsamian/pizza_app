/*import 'package:floor/floor.dart';

@Entity(tableName: 'options')
class Option {
  @PrimaryKey(autoGenerate: true)  // ◀ Attention à la majuscule 'P' dans PrimaryKey
  final int? id;

  @ColumnInfo(name: 'product_id')
  final int productId;

  final String name;

  final double price;

  // "add" pour ajouter au prix, "replace" pour remplacer le prix de base
  final String type;

  @ColumnInfo(name: 'is_active')
  final bool isActive;

  Option({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.type,
    this.isActive = true,
  });
}
*/
