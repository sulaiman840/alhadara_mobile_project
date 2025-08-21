import 'package:bloc/bloc.dart';
import '../data/repositories/my_courses_repository.dart';
import 'my_courses_state.dart';
import '../data/models/enrolled_course_model.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  final MyCoursesRepository _repository;

  MyCoursesCubit(this._repository) : super(MyCoursesInitial());

  Future<void> fetchFirstPage({int perPage = 10}) async {
    if (!isClosed) emit(MyCoursesLoading());
    try {
      final page1 = await _repository.fetchMyCourses(page: 1, perPage: perPage);
      if (!isClosed) {
        emit(MyCoursesSuccess(
          courses: page1.items,
          currentPage: page1.currentPage,
          lastPage: page1.lastPage,
          perPage: page1.perPage,
          isLoadingMore: false,
        ));
      }
    } catch (e) {
      if (!isClosed) emit(MyCoursesFailure(e.toString()));
    }
  }

  Future<void> fetchNextPage() async {
    final s = state;
    if (s is! MyCoursesSuccess) return;
    if (s.isLoadingMore || !s.canLoadMore) return;

    emit(s.copyWith(isLoadingMore: true));
    final next = s.currentPage + 1;

    try {
      final res = await _repository.fetchMyCourses(page: next, perPage: s.perPage);
      final merged = _mergeUniqueById(s.courses, res.items);
      emit(s.copyWith(
        courses: merged,
        currentPage: res.currentPage,
        lastPage: res.lastPage,
        isLoadingMore: false,
      ));
    } catch (_) {

      emit(s.copyWith(isLoadingMore: false));
    }
  }

  List<EnrolledCourseModel> _mergeUniqueById(
      List<EnrolledCourseModel> a, List<EnrolledCourseModel> b) {
    final seen = <int>{for (final e in a) e.id};
    final out = List<EnrolledCourseModel>.from(a);
    for (final e in b) {
      if (seen.add(e.id)) out.add(e);
    }
    return out;
  }
}
