import 'package:equatable/equatable.dart';
import '../../home/data/models/course_model.dart';
import '../../my_course_details/data/models/enrolled_course_model.dart';
import '../data/model/saved_course_model.dart';

abstract class SavedCoursesState extends Equatable {
  const SavedCoursesState();
  @override
  List<Object?> get props => [];
}

class SavedCoursesLoading extends SavedCoursesState {}

class SavedCoursesLoaded extends SavedCoursesState {
  final List<SavedCourse> courses;
  final int count;

  const SavedCoursesLoaded(this.courses, this.count);

  @override
  List<Object?> get props => [courses, count];
}

class SavedCoursesNavigate extends SavedCoursesState {
  final bool isEnrolled;
  final CourseModel courseModel;
  final EnrolledCourseModel? enrolledModel;

  const SavedCoursesNavigate({
    required this.isEnrolled,
    required this.courseModel,
    this.enrolledModel,
  });

  @override
  List<Object?> get props => [isEnrolled, courseModel, enrolledModel];
}

class SavedCoursesError extends SavedCoursesState {
  final String message;
  const SavedCoursesError(this.message);

  @override
  List<Object?> get props => [message];
}
