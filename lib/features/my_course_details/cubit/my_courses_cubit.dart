
import 'package:bloc/bloc.dart';
import '../data/repositories/my_courses_repository.dart';
import 'my_courses_state.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  final MyCoursesRepository _repository;

  MyCoursesCubit(this._repository) : super(MyCoursesInitial());

  Future<void> fetchMyCourses() async {
    if (!isClosed) emit(MyCoursesLoading());

    try {
      final courses = await _repository.fetchMyCourses();
      if (!isClosed) emit(MyCoursesSuccess(courses));
    } catch (e) {
      if (!isClosed) emit(MyCoursesFailure(e.toString()));
    }
  }
}
