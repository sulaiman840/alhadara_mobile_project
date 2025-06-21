// lib/features/ratings/data/datasources/ratings_remote_data_source.dart

import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../models/rating_model.dart';
import '../models/ratings_page_model.dart';

abstract class RatingsRemoteDataSource {
  Future<Either<Exception, RatingsPageModel>> fetchTrainerRatings(int trainerId, int sectionId);
  Future<Either<Exception, RatingsPageModel>> fetchSectionRatings(int sectionId);
  Future<Either<Exception, RatingModel>> submitTrainerRating({
    required int trainerId,
    required int sectionId,
    required int rating,
    required String comment,
  });
  Future<Either<Exception, RatingModel>> submitSectionRating({
    required int sectionId,
    required int rating,
    required String comment,
  });
}

class RatingsRemoteDataSourceImpl implements RatingsRemoteDataSource {
  final ApiService _api;

  RatingsRemoteDataSourceImpl(this._api);

  @override
  Future<Either<Exception, RatingsPageModel>> fetchTrainerRatings(int trainerId, int sectionId) async {
    final either = await _api.get(
      'api/trainer-rating/$trainerId/section/$sectionId/ratings',
          (json) => RatingsPageModel.fromJson(json as Map<String, dynamic>),
    );
    return either.fold(
          (failure) => left(Exception('Failed to load trainer ratings')),
          (page)    => right(page),
    );
  }

  @override
  Future<Either<Exception, RatingsPageModel>> fetchSectionRatings(int sectionId) async {
    final either = await _api.get(
      'api/section-rating/$sectionId/ratings',
          (json) => RatingsPageModel.fromJson(json as Map<String, dynamic>),
    );
    return either.fold(
          (_)   => left(Exception('Failed to load section ratings')),
          (page) => right(page),
    );
  }

  @override
  Future<Either<Exception, RatingModel>> submitTrainerRating({
    required int trainerId,
    required int sectionId,
    required int rating,
    required String comment,
  }) async {
    final either = await _api.post(
      'api/trainer-rating/rate',
      {
        'trainer_id': trainerId,
        'course_section_id': sectionId,
        'rating': rating,
        'comment': comment,
      },
          (json) => RatingModel.fromJson((json as Map<String, dynamic>)['data']),
    );
    return either.fold(
          (_)      => left(Exception('Failed to submit trainer rating')),
          (rating) => right(rating),
    );
  }

  @override
  Future<Either<Exception, RatingModel>> submitSectionRating({
    required int sectionId,
    required int rating,
    required String comment,
  }) async {
    final either = await _api.post(
      'api/section-rating/rate',
      {
        'course_section_id': sectionId,
        'rating': rating,
        'comment': comment,
      },
          (json) => RatingModel.fromJson((json as Map<String, dynamic>)['data']),
    );
    return either.fold(
          (_)      => left(Exception('Failed to submit section rating')),
          (rating) => right(rating),
    );
  }
}
