class Pizza {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final String? image;

  Pizza({this.id, required this.name, this.description, required this.price, this.image});

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] as num? ?? 0).toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Ne pas inclure l'ID car il est géré par la base de données
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
