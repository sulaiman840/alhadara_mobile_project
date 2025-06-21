// lib/features/saved_courses/cubit/saved_courses_state.dart

import 'package:equatable/equatable.dart';
import '../../home/data/models/course_model.dart';
import '../../my_course_details/data/models/enrolled_course_model.dart';
import '../data/model/saved_course_model.dart';

abstract class SavedCoursesState extends Equatable {
  const SavedCoursesState();
  @override
  List<Object?> get props => [];
}

/// When we're loading the list of saved courses
class SavedCoursesLoading extends SavedCoursesState {}

/// When the list of saved courses has loaded
class SavedCoursesLoaded extends SavedCoursesState {
  final List<SavedCourse> courses;
  final int count;

  const SavedCoursesLoaded(this.courses, this.count);

  @override
  List<Object?> get props => [courses, count];
}

/// Emitted once the user taps a course and we’ve determined
/// whether they’re already enrolled or not.
class SavedCoursesNavigate extends SavedCoursesState {
  /// true if already enrolled → go to MyCourseDetailsPage
  final bool isEnrolled;

  /// always include the minimal CourseModel for the “not-enrolled” path
  final CourseModel courseModel;

  /// the enrolled-course info for the “already enrolled” path
  final EnrolledCourseModel? enrolledModel;

  const SavedCoursesNavigate({
    required this.isEnrolled,
    required this.courseModel,
    this.enrolledModel,
  });

  @override
  List<Object?> get props => [isEnrolled, courseModel, enrolledModel];
}

/// If fetching / toggling fails
class SavedCoursesError extends SavedCoursesState {
  final String message;
  const SavedCoursesError(this.message);

  @override
  List<Object?> get props => [message];
}
