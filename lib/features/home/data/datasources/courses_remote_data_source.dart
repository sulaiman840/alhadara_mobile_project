
import 'package:dio/dio.dart';
import '../models/course_model.dart';

abstract class CoursesRemoteDataSource {
  /// Fetches all courses in a given department.
  Future<List<CourseModel>> getCoursesByDepartment(int departmentId);
}

class CoursesRemoteDataSourceImpl implements CoursesRemoteDataSource {
  final Dio _dio;
  CoursesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CourseModel>> getCoursesByDepartment(int departmentId) async {
    final path = 'api/student/departments/$departmentId/courses';
    try {
      final response = await _dio.get(path);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('courses') && data['courses'] is Map<String, dynamic>) {
          final paginated = data['courses'] as Map<String, dynamic>;
          final List<dynamic> rawList = paginated['data'] as List<dynamic>;
          return rawList
              .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          return [];
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
