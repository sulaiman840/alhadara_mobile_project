
import 'package:dio/dio.dart';
import '../models/section_model.dart';

abstract class SectionsRemoteDataSource {
  /// GET /api/section/showAllCourseSectionIsPending/:courseId
  Future<List<SectionModel>> getPendingSections(int courseId);

  /// POST /api/student/reservation/createReservation/:section_id
  /// Returns the raw "message" field from the JSON response.
  Future<String> registerSection(int sectionId);
}

class SectionsRemoteDataSourceImpl implements SectionsRemoteDataSource {
  final Dio _dio;
  SectionsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SectionModel>> getPendingSections(int courseId) async {
    final path = 'api/section/showAllCourseSectionIsPending/$courseId';
    final response = await _dio.get(path);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> rawList = data['data'] as List<dynamic>;
      return rawList
          .map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<String> registerSection(int sectionId) async {
    final path = 'api/student/reservation/createReservation/$sectionId';
    final response = await _dio.post(path);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // The backend returns something like:
      //   { "message": "Your reservation has been successfully completed. Please pay within 48 hours." }
      final data = response.data as Map<String, dynamic>;
      return data['message'] as String;
    } else {
      // If the server returns 4xx/5xx, we still try to pick up a message if present.
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'] as String;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
