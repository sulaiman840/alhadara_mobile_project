
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/complaint_model.dart';

abstract class ComplaintsRemoteDataSource {
  /// Submits a complaint. [file] may be null (text‐only) or a small image/doc/etc.
  Future<ComplaintResponse> submitComplaint({
    required String description,
    File? file,
  });
}

class ComplaintsRemoteDataSourceImpl implements ComplaintsRemoteDataSource {
  final Dio _dio;
  ComplaintsRemoteDataSourceImpl(this._dio);

  @override
  Future<ComplaintResponse> submitComplaint({
    required String description,
    File? file,
  }) async {
    const path = 'api/student/complaints';
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('description', description));

      if (file != null) {
        final fileName = file.path.split(Platform.pathSeparator).last;
        formData.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ComplaintResponse.fromJson(response.data as Map<String, dynamic>);
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
