
import 'package:equatable/equatable.dart';
import '../data/models/recommended_course_model.dart';

abstract class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object?> get props => [];
}

class RecommendationsInitial extends RecommendationsState {}

class RecommendationsLoading extends RecommendationsState {}

class RecommendationsSuccess extends RecommendationsState {
  final List<RecommendedCourse> courses;
  const RecommendationsSuccess(this.courses);

  @override
  List<Object?> get props => [courses];
}

class RecommendationsFailure extends RecommendationsState {
  final String errorMessage;
  const RecommendationsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
