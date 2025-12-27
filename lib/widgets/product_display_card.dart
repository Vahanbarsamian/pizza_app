import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../database/app_database.dart';
import '../screens/admin_edit_product_screen.dart';
import '../screens/pizza_detail_screen.dart';
import '../screens/drink_detail_screen.dart';

class ProductDisplayCard extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  final bool ordersEnabled;

  const ProductDisplayCard({super.key, required this.product, required this.isAdmin, required this.ordersEnabled});

  @override
  Widget build(BuildContext context) {
    final hasImage = product.image != null && product.image!.isNotEmpty;
    final hasDiscount = product.discountPercentage > 0;
    final reducedPrice = product.basePrice * (1 - product.discountPercentage);
    final isNew = DateTime.now().difference(product.createdAt).inDays <= 15;
    
    // ✅ AJOUT : État de rupture de stock
    final isOutOfStock = product.isOutOfStock;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (product.isDrink) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => DrinkDetailScreen(product: product, ordersEnabled: ordersEnabled)),
            );
          } else {
             Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PizzaDetailScreen(product: product, ordersEnabled: ordersEnabled),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ✅ MODIFIÉ : Filtre de couleur grise si épuisé
                  hasImage
                      ? ColorFiltered(
                          colorFilter: isOutOfStock 
                            ? ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.saturation)
                            : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                          child: CachedNetworkImage(
                              imageUrl: product.image!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => _buildPlaceholderIcon(),
                            ),
                        )
                      : _buildPlaceholderIcon(),
                  
                  if (isAdmin)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminEditProductScreen(product: product)));
                        },
                      ),
                    ),
                  
                  if (hasDiscount)
                    _buildBanner('PROMO', Colors.amber, Colors.black, Alignment.topLeft),
                  
                  if (isNew && !product.isDrink)
                    _buildBanner('NOUVEAU', Colors.blue, Colors.white, Alignment.topRight),

                  // ✅ NOUVEAU : Bandeau ÉPUISÉ
                  if (isOutOfStock)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ÉPUISÉ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: isOutOfStock ? Colors.grey : Colors.black, // Grise le titre
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (hasDiscount)
                        Text(
                          '${product.basePrice.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isOutOfStock ? Colors.grey : (hasDiscount ? Colors.red : Colors.black),
                          ),
                          children: [
                            TextSpan(text: (hasDiscount ? reducedPrice : product.basePrice).toStringAsFixed(2)),
                            const TextSpan(
                              text: ' € TTC',
                              style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: FaIcon(
          product.isDrink ? FontAwesomeIcons.bottleWater : FontAwesomeIcons.pizzaSlice,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildBanner(String text, Color backgroundColor, Color textColor, Alignment alignment) {
    final isTopLeft = alignment == Alignment.topLeft;
    return Banner(
      message: text,
      location: isTopLeft ? BannerLocation.topStart : BannerLocation.topEnd,
      color: backgroundColor,
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}
