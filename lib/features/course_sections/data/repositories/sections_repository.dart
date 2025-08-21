
import '../datasources/sections_remote_data_source.dart';
import '../models/section_model.dart';

abstract class SectionsRepository {
  Future<List<SectionModel>> fetchPendingSections(int courseId);

  Future<String> registerSection(int sectionId);
}

class SectionsRepositoryImpl implements SectionsRepository {
   final SectionsRemoteDataSource _remoteDataSource;
  SectionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<SectionModel>> fetchPendingSections(int courseId) {
    return _remoteDataSource.getPendingSections(courseId);
  }

  @override
  Future<String> registerSection(int sectionId) {
    return _remoteDataSource.registerSection(sectionId);
  }
}
