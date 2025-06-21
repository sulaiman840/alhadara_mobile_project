// lib/features/saved_courses/data/datasources/saved_courses_remote_data_source.dart

import 'package:dio/dio.dart';
import '../model/saved_course_model.dart';

abstract class SavedCoursesRemoteDataSource {
  Future<List<SavedCourse>> fetchSavedCourses({int perPage = 10});
  Future<int> fetchSavedCount();
  Future<void> saveCourse(int courseId);
  Future<void> unsaveCourse(int courseId);
}

class SavedCoursesRemoteDataSourceImpl implements SavedCoursesRemoteDataSource {
  final Dio _dio;
  SavedCoursesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SavedCourse>> fetchSavedCourses({int perPage = 10}) async {
    final resp = await _dio.get(
      'api/saved-courses',
      queryParameters: {'per_page': perPage},
    );
    if (resp.statusCode == 429) {
      // Throw a DioException so the Cubit can catch it
      throw DioException(
        requestOptions: resp.requestOptions,
        response: resp,
        type: DioExceptionType.badResponse,
      );
    }
    // you can also guard resp.statusCode != 200 here similarly...
    final raw = (resp.data['saved_courses']['data'] as List);
    return raw
        .map((j) => SavedCourse.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> fetchSavedCount() async {
    final resp = await _dio.get('api/saved-courses/count');
    if (resp.statusCode == 429) {
      throw DioException(
        requestOptions: resp.requestOptions,
        response: resp,
        type: DioExceptionType.badResponse,
      );
    }
    return resp.data['count'] as int;
  }

  @override
  Future<void> saveCourse(int courseId) async {
    final resp = await _dio.post('api/courses/$courseId/save');
    if (resp.statusCode == 429) {
      throw DioException(
        requestOptions: resp.requestOptions,
        response: resp,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<void> unsaveCourse(int courseId) async {
    final resp = await _dio.delete('api/courses/$courseId/unsave');
    if (resp.statusCode == 429) {
      throw DioException(
        requestOptions: resp.requestOptions,
        response: resp,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
