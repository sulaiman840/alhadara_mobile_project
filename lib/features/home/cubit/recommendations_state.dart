// lib/features/home/cubit/recommendations_state.dart

import 'package:equatable/equatable.dart';
import '../data/models/recommended_course_model.dart';

abstract class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object?> get props => [];
}

/// Initial (nothing yet)
class RecommendationsInitial extends RecommendationsState {}

/// Currently fetching
class RecommendationsLoading extends RecommendationsState {}

/// Successfully fetched
class RecommendationsSuccess extends RecommendationsState {
  final List<RecommendedCourse> courses;
  const RecommendationsSuccess(this.courses);

  @override
  List<Object?> get props => [courses];
}

/// Failure, with a localized message
class RecommendationsFailure extends RecommendationsState {
  final String errorMessage;
  const RecommendationsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
