import 'rating_model.dart';
class RatingsPageModel {
  final List<RatingModel> ratings;
  final double averageRating;
  RatingsPageModel({ required this.ratings, required this.averageRating });
  factory RatingsPageModel.fromJson(Map<String,dynamic> json) {
    final list = (json['ratings'] as List).map((e) => RatingModel.fromJson(e)).toList();
    final avg = double.tryParse(json['average_rating']?.toString() ?? '') ?? 0.0;
    return RatingsPageModel(ratings: list, averageRating: avg);
  }
}