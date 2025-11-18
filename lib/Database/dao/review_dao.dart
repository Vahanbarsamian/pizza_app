import 'package:floor/floor.dart';
import '../review.dart';

@dao
abstract class ReviewDao {
  @Query('SELECT * FROM Review')
  Future<List<Review>> getAllReviews();

  @Query('SELECT * FROM Review WHERE userId = :userId')
  Future<List<Review>> findReviewsByUserId(int userId);

  @insert
  Future<void> insertReview(Review review);

  @update
  Future<void> updateReview(Review review);

  @delete
  Future<void> deleteReview(Review review);
}
