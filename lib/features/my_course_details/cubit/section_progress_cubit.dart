import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/section_progress_repository.dart';
import 'section_progress_state.dart';

class SectionProgressCubit extends Cubit<SectionProgressState> {
  final SectionProgressRepository repository;

  SectionProgressCubit(this.repository) : super(SectionProgressInitial());

  Future<void> load(int sectionId) async {
    try {
      emit(SectionProgressLoading());
      final result = await repository.fetchProgress(sectionId);
      final clamped = result.progressPercentage.clamp(0, 100);
      emit(SectionProgressSuccess(clamped));
    } catch (e) {
      emit(SectionProgressFailure(e.toString()));
    }
  }
}
