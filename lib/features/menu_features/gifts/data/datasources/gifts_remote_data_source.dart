
import 'package:dio/dio.dart';
import '../models/gift_model.dart';

abstract class GiftsRemoteDataSource {

  Future<List<GiftModel>> getStudentGifts();
}

class GiftsRemoteDataSourceImpl implements GiftsRemoteDataSource {
  final Dio _dio;

  GiftsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<GiftModel>> getStudentGifts() async {
    const path = 'api/student/gifts';

    try {
      final response = await _dio.get(path);

      if (response.statusCode == 200) {

        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('gifts') && data['gifts'] is List) {
          final List giftsJson = data['gifts'] as List;
          return giftsJson
              .map((giftJson) =>
              GiftModel.fromJson(giftJson as Map<String, dynamic>))
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
    } on DioException catch (e) {
      rethrow;
    }
  }
}
