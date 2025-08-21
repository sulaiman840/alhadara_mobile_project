import 'package:equatable/equatable.dart';
import '../data/models/ratings_page_model.dart';

abstract class CourseRatingsState extends Equatable {
  const CourseRatingsState();
  @override
  List<Object?> get props => [];
}

class CourseRatingsInitial extends CourseRatingsState {}
class CourseRatingsLoading extends CourseRatingsState {}
class CourseRatingsLoaded extends CourseRatingsState {
  final RatingsPageModel page;
  const CourseRatingsLoaded(this.page);
  @override
  List<Object?> get props => [page];
}
class CourseRatingsFailure extends CourseRatingsState {
  final String message;
  const CourseRatingsFailure(this.message);
  @override
  List<Object?> get props => [message];
}
