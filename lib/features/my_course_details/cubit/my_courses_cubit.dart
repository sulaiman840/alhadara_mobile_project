import 'package:bloc/bloc.dart';
import '../data/repositories/my_courses_repository.dart';
import '../data/models/enrolled_course_model.dart';
import 'my_courses_state.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  final MyCoursesRepository _repository;
  MyCoursesCubit(this._repository) : super(MyCoursesInitial());

  void fetchMyCourses() async {
    emit(MyCoursesLoading());
    try {
      final courses = await _repository.fetchMyCourses();
      emit(MyCoursesSuccess(courses));
    } catch (e) {
      emit(MyCoursesFailure(e.toString()));
    }
  }
}