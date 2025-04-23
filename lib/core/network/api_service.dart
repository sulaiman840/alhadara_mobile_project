import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'statusrequest.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<Either<StatusRequest, T>> get<T>(
      String path,
      T Function(dynamic json) parser,
      ) async {
    try {
      final response = await _dio.get(path);
      if (response.statusCode == 200) {
        return Right(parser(response.data));
      }
      return const Left(StatusRequest.serverfailure);
    } on DioException catch (e) {
      if (e.type == DioErrorType.unknown) {
        return const Left(StatusRequest.offlinefailure);
      }
      return const Left(StatusRequest.failure);
    }
  }

  Future<Either<StatusRequest, T>> post<T>(
      String path,
      Map<String, dynamic> body,
      T Function(dynamic json) parser,
      ) async {
    try {
      final response = await _dio.post(path, data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(parser(response.data));
      }
      return const Left(StatusRequest.serverfailure);
    } on DioError catch (e) {
      if (e.type == DioExceptionType.unknown) {
        return const Left(StatusRequest.offlinefailure);
      }
      return const Left(StatusRequest.failure);
    }
  }
}
