
import '../datasources/section_files_remote_data_source.dart';
import '../models/section_file_model.dart';

abstract class SectionFilesRepository {
  Future<List<SectionFile>> getFiles(int sectionId);
}

class SectionFilesRepositoryImpl implements SectionFilesRepository {
  final SectionFilesRemoteDataSource _remote;
  SectionFilesRepositoryImpl(this._remote);

  @override
  Future<List<SectionFile>> getFiles(int sectionId) =>
      _remote.fetchFiles(sectionId);
}
