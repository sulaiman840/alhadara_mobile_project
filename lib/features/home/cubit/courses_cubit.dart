
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../data/models/course_model.dart';
import '../data/repositories/courses_repository.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CoursesRepository _repository;

  List<CourseModel> _allCourses = [];

  CoursesCubit(this._repository) : super(CoursesInitial());

  Future<void> fetchCourses(int departmentId) async {
    if (state is CoursesLoading) return;
    emit(CoursesLoading());
    try {
      final list = await _repository.fetchCoursesByDepartment(departmentId);
      _allCourses = list;
      emit(CoursesSuccess(list));
    } on DioException catch (e) {
      String msg = 'حدث خطأ أثناء جلب الكورسات';
      if (e.response?.data is Map<String, dynamic>) {
        final raw = e.response!.data as Map<String, dynamic>;
        if (raw.containsKey('message') && raw['message'] is String) {
          msg = raw['message'] as String;
        }
      }
      print(msg);
      emit(CoursesFailure(msg));
    } catch (_) {
      print(CoursesFailure);
      emit(const CoursesFailure('حدث خطأ غير متوقع'));
    }
  }

  CourseModel? findById(int id) {
    try {
      return _allCourses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
