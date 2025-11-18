import 'package:floor/floor.dart';

@entity
class Review {
  @primaryKey
  final int? id;
  final int userId;
  final int note;
  final String? comment;
  final String createdAt;

  Review({
    this.id,
    required this.userId,
    required this.note,
    this.comment,
    required this.createdAt,
  });
}
