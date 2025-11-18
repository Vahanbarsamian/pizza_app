import 'package:floor/floor.dart';

@entity
class Order {
  @primaryKey
  final int? id;
  final int userId;
  final double total;
  final String status;
  final String createdAt; // Stocker en String ISO date, car Floor ne gère pas TIMESTAMP

  Order({
    this.id,
    required this.userId,
    required this.total,
    required this.status,
    required this.createdAt,
  });
}
