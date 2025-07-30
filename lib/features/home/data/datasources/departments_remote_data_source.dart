
import 'package:dio/dio.dart';
import '../models/department_model.dart';

abstract class DepartmentsRemoteDataSource {

  Future<List<DepartmentModel>> getDepartments();
}

class DepartmentsRemoteDataSourceImpl implements DepartmentsRemoteDataSource {
  final Dio _dio;
  DepartmentsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<DepartmentModel>> getDepartments() async {
    const path = 'api/student/departments';
    try {
      final response = await _dio.get(path);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('departments') &&
            data['departments'] is Map<String, dynamic>) {
          final paginated = data['departments'] as Map<String, dynamic>;
          final List<dynamic> rawList = paginated['data'] as List<dynamic>;
          return rawList
              .map((json) =>
              DepartmentModel.fromJson(json as Map<String, dynamic>))
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
