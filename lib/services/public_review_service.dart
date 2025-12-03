import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import '../database/app_database.dart';

enum ReviewFilter { all, week, month, year }

class PublicReviewService extends ChangeNotifier {
  final AppDatabase _db;
  List<ReviewWithOrder> _allReviews = [];
  List<ReviewWithOrder> _filteredReviews = [];
  ReviewFilter _activeFilter = ReviewFilter.all;

  PublicReviewService(this._db) {
    _db.watchAllPublicReviews().listen((reviews) {
      _allReviews = reviews;
      _applyFilter();
    });
  }

  List<ReviewWithOrder> get reviews => _filteredReviews;
  int get totalReviews => _allReviews.length;
  double get averageRating {
    if (_allReviews.isEmpty) return 0.0;
    final totalRating = _allReviews.fold<double>(0.0, (sum, item) => sum + item.review.rating);
    return totalRating / _allReviews.length;
  }

  ReviewFilter get activeFilter => _activeFilter;

  void setFilter(ReviewFilter filter) {
    _activeFilter = filter;
    _applyFilter();
  }

  void _applyFilter() {
    final now = DateTime.now();
    switch (_activeFilter) {
      case ReviewFilter.week:
        _filteredReviews = _allReviews.where((item) => now.difference(item.review.createdAt).inDays <= 7).toList();
        break;
      case ReviewFilter.month:
        _filteredReviews = _allReviews.where((item) => now.difference(item.review.createdAt).inDays <= 30).toList();
        break;
      case ReviewFilter.year:
        _filteredReviews = _allReviews.where((item) => now.difference(item.review.createdAt).inDays <= 365).toList();
        break;
      case ReviewFilter.all:
      default:
        _filteredReviews = List.from(_allReviews);
        break;
    }
    notifyListeners();
  }
}
