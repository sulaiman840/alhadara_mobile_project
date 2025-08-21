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
  final int currentPage;
  final int lastPage;
  final int perPage;
  final bool isLoadingMore;

  const MyCoursesSuccess({
    required this.courses,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.isLoadingMore = false,
  });

  bool get canLoadMore => currentPage < lastPage;

  MyCoursesSuccess copyWith({
    List<EnrolledCourseModel>? courses,
    int? currentPage,
    int? lastPage,
    int? perPage,
    bool? isLoadingMore,
  }) {
    return MyCoursesSuccess(
      courses: courses ?? this.courses,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [courses, currentPage, lastPage, perPage, isLoadingMore];
}

class MyCoursesFailure extends MyCoursesState {
  final String errorMessage;
  const MyCoursesFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
