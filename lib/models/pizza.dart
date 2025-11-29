class Pizza {
  final int id;
  final String name;
  final double price;

  Pizza({required this.id, required this.name, required this.price});

  factory Pizza.fromJson(Map<String, dynamic> json) => Pizza(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    price: json['price']?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
  };
}