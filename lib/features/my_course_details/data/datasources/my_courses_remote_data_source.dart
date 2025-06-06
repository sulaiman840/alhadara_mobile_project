import 'package:dio/dio.dart';
import '../models/enrolled_course_model.dart';

abstract class MyCoursesRemoteDataSource {
  Future<List<EnrolledCourseModel>> getMyCourses();
}

class MyCoursesRemoteDataSourceImpl implements MyCoursesRemoteDataSource {
  final Dio _dio;
  MyCoursesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<EnrolledCourseModel>> getMyCourses() async {
    final response = await _dio.get('api/student/my-courses');
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final rawList = data['courses'] as List<dynamic>;
      return rawList
          .map((e) => EnrolledCourseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}