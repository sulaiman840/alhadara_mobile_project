import 'package:equatable/equatable.dart';
import '../../finished_courses/data/models/finished_course_model.dart';

abstract class FinishedCoursesState extends Equatable {
  const FinishedCoursesState();
  @override
  List<Object?> get props => [];
}

class FinishedCoursesInitial extends FinishedCoursesState {}

class FinishedCoursesLoading extends FinishedCoursesState {}

class FinishedCoursesLoaded extends FinishedCoursesState {
  final List<FinishedCourseModel> courses;
  const FinishedCoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class FinishedCoursesError extends FinishedCoursesState {
  final String errorMessage;
  const FinishedCoursesError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
