
// lib/features/ratings/cubit/ratings_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/ratings_repository.dart';
import 'ratings_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  final RatingsRepository _repo;
  RatingsCubit(this._repo) : super(RatingsInitial());

  Future<void> loadTrainerRatings(int trainerId, int sectionId) async {
    emit(RatingsLoading());
    final res = await _repo.getTrainerRatings(trainerId, sectionId);
    res.fold(
          (err) => emit(RatingsFailure(err)),
          (page) => emit(RatingsLoaded(page)),
    );
  }

  Future<void> loadSectionRatings(int sectionId) async {
    emit(RatingsLoading());
    final res = await _repo.getSectionRatings(sectionId);
    res.fold(
          (err) => emit(RatingsFailure(err)),
          (page) => emit(RatingsLoaded(page)),
    );
  }

  Future<void> submitTrainerRating({
    required int trainerId,
    required int sectionId,
    required int rating,
    required String comment,
  }) async {
    emit(RatingsSubmitting());
    final res = await _repo.rateTrainer(
      trainerId: trainerId,
      sectionId: sectionId,
      rating: rating,
      comment: comment,
    );
    res.fold(
          (err) => emit(RatingsFailure(err)),
          (model) => emit(RatingsSubmitSuccess(model)),
    );
  }

  Future<void> submitSectionRating({
    required int sectionId,
    required int rating,
    required String comment,
  }) async {
    emit(RatingsSubmitting());
    final res = await _repo.rateSection(
      sectionId: sectionId,
      rating: rating,
      comment: comment,
    );
    res.fold(
          (err) => emit(RatingsFailure(err)),
          (model) => emit(RatingsSubmitSuccess(model)),
    );
  }
}
