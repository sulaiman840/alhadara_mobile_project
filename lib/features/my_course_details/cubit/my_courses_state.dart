import 'package:equatable/equatable.dart';
import '../data/models/enrolled_course_model.dart';

abstract class MyCoursesState extends Equatable {
  const MyCoursesState();
  @override
  List<Object?> get props => [];
}

class MyCoursesInitial extends MyCoursesState {}
class MyCoursesLoading extends MyCoursesState {}
class MyCoursesSuccess extends MyCoursesState {
  final List<EnrolledCourseModel> courses;
  const MyCoursesSuccess(this.courses);
  @override
  List<Object?> get props => [courses];
}

class MyCoursesFailure extends MyCoursesState {
  final String errorMessage;
  const MyCoursesFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}