import 'rating_model.dart';


class RatingsPageModel {
  final List<RatingModel> ratings;
  final double averageRating;

  RatingsPageModel({
    required this.ratings,
    required this.averageRating,
  });

  factory RatingsPageModel.fromJson(Map<String, dynamic> json) {
    // parse ratings list
    final list = (json['ratings'] as List<dynamic>?)
        ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [];

    // robust parsing of average_rating
    final avgRaw = json['average_rating'];
    double avg;
    if (avgRaw is String) {
      avg = double.tryParse(avgRaw) ?? 0.0;
    } else if (avgRaw is num) {
      avg = avgRaw.toDouble();
    } else {
      avg = 0.0;
    }

    return RatingsPageModel(
      ratings: list,
      averageRating: avg,
    );
  }
}