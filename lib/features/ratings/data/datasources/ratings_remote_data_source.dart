import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../models/rating_model.dart';
import '../models/ratings_page_model.dart';

abstract class RatingsRemoteDataSource {
  Future<Either<Exception, RatingsPageModel>> fetchSectionRatings(int sectionId);
  Future<Either<Exception, RatingModel>> submitSectionRating({
    required int sectionId, required int rating, String? comment,
  });
}

class RatingsRemoteDataSourceImpl implements RatingsRemoteDataSource {
  final ApiService _api;

  RatingsRemoteDataSourceImpl(this._api);

  @override
  Future<Either<Exception, RatingsPageModel>> fetchSectionRatings(
      int sectionId) async {
    final res = await _api.get(
      'api/section-rating/$sectionId/ratings',
          (json) => RatingsPageModel.fromJson(json as Map<String, dynamic>),
    );
    return res.fold((_) => left(Exception('Failed to load ratings')), right);
  }

  @override
  Future<Either<Exception, RatingModel>> submitSectionRating({
    required int sectionId,
    required int rating,
    String? comment,
  }) async {
    final res = await _api.post(
      'api/section-rating/rate',
      {
        'section_id': sectionId,
        'rating': rating,
        if (comment != null) 'comment': comment,
      },
          (json) {
        final raw = json as Map<String, dynamic>;

        final payload = raw['data'] is Map<String, dynamic>
            ? raw['data'] as Map<String, dynamic>
            : raw;

        return RatingModel.fromJson(payload);
      },
    );

    return res.fold((e) => left(Exception(e.toString())), right);
  }
}