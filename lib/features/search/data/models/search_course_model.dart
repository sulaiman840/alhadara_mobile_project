// lib/features/home/data/models/search_course_model.dart

import 'package:equatable/equatable.dart';
import '../../../home/data/models/course_model.dart';

class SearchCourseModel extends Equatable {
  final List<CourseModel> courses;
  final int currentPage, lastPage, total;

  const SearchCourseModel({
    required this.courses,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory SearchCourseModel.fromJson(Map<String, dynamic> json) {
    final data = json['courses'] as Map<String, dynamic>;
    final page = data['current_page'] as int;
    final last = data['last_page'] as int;
    final tot  = data['total'] as int;
    final items = (data['data'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => CourseModel.fromJson(e))
        .toList();

    return SearchCourseModel(
      courses: items,
      currentPage: page,
      lastPage: last,
      total: tot,
    );
  }

  @override
  List<Object?> get props => [courses, currentPage, lastPage, total];
}
