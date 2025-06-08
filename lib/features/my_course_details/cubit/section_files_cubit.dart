
import 'package:bloc/bloc.dart';
import '../data/repositories/section_files_repository.dart';
import 'section_files_state.dart';

class SectionFilesCubit extends Cubit<SectionFilesState> {
  final SectionFilesRepository _repo;
  SectionFilesCubit(this._repo) : super(SectionFilesLoading());

  Future<void> fetchFiles(int sectionId) async {
    try {
      final list = await _repo.getFiles(sectionId);
      emit(SectionFilesLoaded(list));
    } catch (_) {
      emit(const SectionFilesError('فشل في جلب الواجبات'));
    }
  }
}
