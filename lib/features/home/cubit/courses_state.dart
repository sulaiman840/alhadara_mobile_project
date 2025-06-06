
import 'package:equatable/equatable.dart';
import '../data/models/course_model.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesSuccess extends CoursesState {
  final List<CourseModel> courses;
  const CoursesSuccess(this.courses);

  @override
  List<Object?> get props => [courses];
}

class CoursesFailure extends CoursesState {
  final String errorMessage;
  const CoursesFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
