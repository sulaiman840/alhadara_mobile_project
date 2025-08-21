import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/enrolled_course_model.dart';

/// One-page result from the API with pagination meta.
class MyCoursesPageResult {
  final List<EnrolledCourseModel> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const MyCoursesPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

abstract class MyCoursesRemoteDataSource {
  Future<MyCoursesPageResult> getMyCourses({int page = 1, int perPage = 10});
}

class MyCoursesRemoteDataSourceImpl implements MyCoursesRemoteDataSource {
  final Dio _dio;
  MyCoursesRemoteDataSourceImpl(this._dio);

  @override
  Future<MyCoursesPageResult> getMyCourses({int page = 1, int perPage = 10}) async {
    try {
      final response = await _dio.get(
        'api/student/my-courses',
        queryParameters: {'page': page, 'per_page': perPage},
        options:  Options(responseType: ResponseType.json),
      );

      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Unexpected status code: $status',
        );
      }

      final dynamic payload =
      response.data is String ? jsonDecode(response.data as String) : response.data;

      if (payload is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Unexpected response shape. Expected a JSON object.',
        );
      }

      // Your API returns "courses" + "pagination" (fallback to "sections" if needed).
      final dynamic rawList = payload['courses'] ?? payload['sections'] ?? [];
      if (rawList is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Expected a list under "courses" or "sections".',
        );
      }

      final List<EnrolledCourseModel> items = rawList
          .map((e) => e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map))
          .map(EnrolledCourseModel.fromJson)
          .toList(growable: false);

      final Map<String, dynamic> pg = (payload['pagination'] as Map?)?.cast<String, dynamic>() ?? const {};
      final int currentPage = (pg['current_page'] as num?)?.toInt() ?? page;
      final int lastPage    = (pg['last_page'] as num?)?.toInt() ?? page;
      final int perPageOut  = (pg['per_page'] as num?)?.toInt() ?? perPage;
      final int total       = (pg['total'] as num?)?.toInt() ?? items.length;

      return MyCoursesPageResult(
        items: items,
        currentPage: currentPage,
        lastPage: lastPage,
        perPage: perPageOut,
        total: total,
      );
    } on DioException {
      rethrow;
    } catch (e, st) {
      throw DioException(
        requestOptions: RequestOptions(path: 'api/student/my-courses'),
        type: DioExceptionType.unknown,
        error: e,
        stackTrace: st,
      );
    }
  }
}
