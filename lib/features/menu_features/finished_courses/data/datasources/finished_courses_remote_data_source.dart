import 'package:dio/dio.dart';
import '../models/finished_course_model.dart';

abstract class FinishedCoursesRemoteDataSource {
  Future<List<FinishedCourseModel>> fetchFinished();
}

class FinishedCoursesRemoteDataSourceImpl implements FinishedCoursesRemoteDataSource {
  final Dio _dio;
  FinishedCoursesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<FinishedCourseModel>> fetchFinished() async {
    final response = await _dio.get('api/student/getMyCourseIsFinished');

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['courses'] as List?) ?? const [];
      return list
          .map((e) => FinishedCourseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }
}
