import '../datasources/section_progress_remote_data_source.dart';
import '../models/section_progress_model.dart';

abstract class SectionProgressRepository {
  Future<SectionProgress> fetchProgress(int sectionId);
}

class SectionProgressRepositoryImpl implements SectionProgressRepository {
  final SectionProgressRemoteDataSource remote;
  SectionProgressRepositoryImpl(this.remote);

  @override
  Future<SectionProgress> fetchProgress(int sectionId) {
    return remote.getProgress(sectionId);
  }
}
