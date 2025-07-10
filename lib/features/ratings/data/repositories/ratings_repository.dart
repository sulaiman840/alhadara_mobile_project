import 'package:dartz/dartz.dart';
import '../datasources/ratings_remote_data_source.dart';
import '../models/rating_model.dart';
import '../models/ratings_page_model.dart';

abstract class RatingsRepository {
  Future<Either<String, RatingsPageModel>> getSectionRatings(int sectionId);
  Future<Either<String, RatingModel>> rateSection({
    required int sectionId,
    required int rating,
    String? comment,
  });
}

class RatingsRepositoryImpl implements RatingsRepository {
  final RatingsRemoteDataSource _remote;
  RatingsRepositoryImpl(this._remote);

  @override
  Future<Either<String, RatingsPageModel>> getSectionRatings(int sectionId) async {
    final r = await _remote.fetchSectionRatings(sectionId);
    return r.fold((e) => left(e.toString()), right);
  }

  @override
  Future<Either<String, RatingModel>> rateSection({
    required int sectionId,
    required int rating,
    String? comment,
  }) async {
    final r = await _remote.submitSectionRating(
      sectionId: sectionId,
      rating: rating,
      comment: comment,
    );
    return r.fold((e) => left(e.toString()), right);
  }
}