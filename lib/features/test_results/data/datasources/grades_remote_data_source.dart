// lib/features/tests/data/datasources/grades_remote_data_source.dart

import 'package:dio/dio.dart';
import '../models/grade_model.dart';

class GradesRemoteDataSource {
  final Dio _dio;

  GradesRemoteDataSource(this._dio);

  /// Fetch “my grades” from the server.
  Future<List<GradeModel>> fetchMyGrades() async {
    final path = 'api/grades/my-grades';
    try {
      final response = await _dio.get(path);
      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final rawList = body['data'] as List<dynamic>;
        return rawList
            .map((e) => GradeModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
