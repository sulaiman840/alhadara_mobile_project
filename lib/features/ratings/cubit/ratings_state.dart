// lib/features/ratings/cubit/ratings_state.dart
import 'package:equatable/equatable.dart';
import '../data/models/rating_model.dart';
import '../data/models/ratings_page_model.dart';

abstract class RatingsState extends Equatable {
  const RatingsState();
  @override
  List<Object?> get props => [];
}

class RatingsInitial extends RatingsState {}
class RatingsLoading extends RatingsState {}
class RatingsLoaded extends RatingsState {
  final RatingsPageModel page;
  const RatingsLoaded(this.page);
  @override List<Object?> get props => [page];
}
class RatingsSubmitting extends RatingsState {}
class RatingsSubmitSuccess extends RatingsState {
  final RatingModel rating;
  const RatingsSubmitSuccess(this.rating);
  @override List<Object?> get props => [rating];
}
class RatingsFailure extends RatingsState {
  final String message;
  const RatingsFailure(this.message);
  @override List<Object?> get props => [message];
}
