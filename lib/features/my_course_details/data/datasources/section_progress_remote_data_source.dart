import 'package:dio/dio.dart';
import '../models/section_progress_model.dart';

abstract class SectionProgressRemoteDataSource {
  Future<SectionProgress> getProgress(int sectionId);
}

class SectionProgressRemoteDataSourceImpl implements SectionProgressRemoteDataSource {
  final Dio dio;
  SectionProgressRemoteDataSourceImpl(this.dio);

  @override
  Future<SectionProgress> getProgress(int sectionId) async {
    final res = await dio.get('api/course-sections/$sectionId/progress');
    final data = res.data is Map<String, dynamic> ? res.data : <String, dynamic>{};
    return SectionProgress.fromJson(data);
  }
}
