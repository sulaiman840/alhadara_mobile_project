import 'package:dio/dio.dart';
import '../models/grade_model.dart';

class GradesRemoteDataSource {
  final Dio _dio;

  GradesRemoteDataSource(this._dio);

  Future<List<GradeModel>> fetchMyGrades() async {
    final response = await _dio.get('api/grades/my-grades');
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final raw = (data['grades'] as Map<String, dynamic>)['data'] as List;
      return raw
          .map((j) => GradeModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }
}
