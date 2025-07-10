import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../data/repositories/ratings_repository.dart';
import 'ratings_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  final RatingsRepository _repo;
  RatingsCubit(this._repo) : super(RatingsInitial());

  Future<void> loadSectionRatings(int sectionId) async {
    emit(RatingsLoading());
    final res = await _repo.getSectionRatings(sectionId);
    res.fold((err) => emit(RatingsFailure(err)), (page) => emit(RatingsLoaded(page)));
  }

  Future<void> submitSectionRating({
    required int sectionId,
    required int rating,
    String? comment,
  }) async {
    emit(RatingsSubmitting());
    final res = await _repo.rateSection(
      sectionId: sectionId,
      rating: rating,
      comment: comment,
    );
    res.fold((err) => emit(RatingsFailure(err)), (m) => emit(RatingsSubmitSuccess(m)));
    // re-load list after submit
    await loadSectionRatings(sectionId);
  }
}