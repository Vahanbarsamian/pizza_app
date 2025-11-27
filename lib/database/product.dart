import 'package:floor/floor.dart';

@Entity(tableName: 'products')
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'name')
  final String? name;

  final String? description;

  @ColumnInfo(name: 'base_price')  // Renommé pour distinguer du prix final
  final double? basePrice;

  final String? image;

  final String? category;

  // ✅ NOUVEAU : Remise globale en pourcentage (ex: 20.0 = 20%)
  @ColumnInfo(name: 'discount_percentage')
  final double? discountPercentage;

  // ✅ NOUVEAU : Active/désactive la remise globale
  @ColumnInfo(name: 'has_global_discount')
  final bool? hasGlobalDiscount;

  Product({
    this.id,
    this.name,
    this.description,
    this.basePrice,
    this.image,
    this.category,
    this.discountPercentage,
    this.hasGlobalDiscount = false,  // Par défaut pas de remise
  });

  // ✅ Méthode pour calculer le prix AVEC remise
  double get discountedPrice {
    if (hasGlobalDiscount == true && discountPercentage != null) {
      return basePrice! * (1 - discountPercentage! / 100);
    }
    return basePrice ?? 0.0;
  }

  // ✅ Copie avec remise modifiée (pour l'admin)
  Product copyWithDiscount(double? newDiscount, bool applyDiscount) {
    return Product(
      id: id,
      name: name,
      description: description,
      basePrice: basePrice,
      image: image,
      category: category,
      discountPercentage: newDiscount,
      hasGlobalDiscount: applyDiscount,
    );
  }
}
