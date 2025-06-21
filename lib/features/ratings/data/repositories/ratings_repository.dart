// lib/features/ratings/data/repositories/ratings_repository.dart
import 'package:dartz/dartz.dart';
import '../datasources/ratings_remote_data_source.dart';
import '../models/ratings_page_model.dart';
import '../models/rating_model.dart';

abstract class RatingsRepository {
  Future<Either<String, RatingsPageModel>> getTrainerRatings(int trainerId, int sectionId);
  Future<Either<String, RatingsPageModel>> getSectionRatings(int sectionId);
  Future<Either<String, RatingModel>> rateTrainer({
    required int trainerId,
    required int sectionId,
    required int rating,
    required String comment,
  });
  Future<Either<String, RatingModel>> rateSection({
    required int sectionId,
    required int rating,
    required String comment,
  });
}

class RatingsRepositoryImpl implements RatingsRepository {
  final RatingsRemoteDataSource _remote;

  RatingsRepositoryImpl(this._remote);

  @override
  Future<Either<String, RatingsPageModel>> getTrainerRatings(int trainerId, int sectionId) async {
    final res = await _remote.fetchTrainerRatings(trainerId, sectionId);
    return res.fold(
          (err) => left(err.toString()),
          (page) => right(page),
    );
  }

  @override
  Future<Either<String, RatingsPageModel>> getSectionRatings(int sectionId) async {
    final res = await _remote.fetchSectionRatings(sectionId);
    return res.fold(
          (err) => left(err.toString()),
          (page) => right(page),
    );
  }

  @override
  Future<Either<String, RatingModel>> rateTrainer({
    required int trainerId,
    required int sectionId,
    required int rating,
    required String comment,
  }) async {
    final res = await _remote.submitTrainerRating(
      trainerId: trainerId,
      sectionId: sectionId,
      rating: rating,
      comment: comment,
    );
    return res.fold(
          (err) => left(err.toString()),
          (model) => right(model),
    );
  }

  @override
  Future<Either<String, RatingModel>> rateSection({
    required int sectionId,
    required int rating,
    required String comment,
  }) async {
    final res = await _remote.submitSectionRating(
      sectionId: sectionId,
      rating: rating,
      comment: comment,
    );
    return res.fold(
          (err) => left(err.toString()),
          (model) => right(model),
    );
  }
}
