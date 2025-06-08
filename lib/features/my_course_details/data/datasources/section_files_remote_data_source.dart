
import 'package:dio/dio.dart';
import '../models/section_file_model.dart';

abstract class SectionFilesRemoteDataSource {
  Future<List<SectionFile>> fetchFiles(int sectionId);
}

class SectionFilesRemoteDataSourceImpl implements SectionFilesRemoteDataSource {
  final Dio _dio;
  SectionFilesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SectionFile>> fetchFiles(int sectionId) async {
    final resp = await _dio.get('api/file/showAllFileInSection/$sectionId');
    if (resp.statusCode == 200) {
      final raw = resp.data['Files']['data'] as List;
      return raw.map((j) => SectionFile.fromJson(j)).toList();
    }
    throw DioException(requestOptions: resp.requestOptions);
  }
}
