import 'package:dio/dio.dart';
import '../models/points_model.dart';

abstract class PointsRemoteDataSource {
  Future<PointsModel> getStudentPoints();
}

class PointsRemoteDataSourceImpl implements PointsRemoteDataSource {
  final Dio _dio;

  PointsRemoteDataSourceImpl(this._dio);

  @override
  Future<PointsModel> getStudentPoints() async {
    const path = 'api/student/points';

    final response = await _dio.get(path);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return PointsModel.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }
}
