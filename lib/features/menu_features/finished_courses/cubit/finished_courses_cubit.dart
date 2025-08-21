import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/models/finished_course_model.dart';
import '../data/repositories/finished_courses_repository.dart';
import 'finished_courses_state.dart';

class FinishedCoursesCubit extends Cubit<FinishedCoursesState> {
  final FinishedCoursesRepository _repository;
  FinishedCoursesCubit(this._repository) : super(FinishedCoursesInitial());

  Future<void> loadFinished() async {
    emit(FinishedCoursesLoading());
    try {
      final List<FinishedCourseModel> list =
      await _repository.getFinishedCourses();
      emit(FinishedCoursesLoaded(list));
    } on DioException catch (e) {
      String msg = 'حدث خطأ أثناء جلب الدورات المكتملة';
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] is String) {
        msg = data['message'] as String;
      }
      emit(FinishedCoursesError(msg));
    } catch (_) {
      emit(const FinishedCoursesError('حدث خطأ غير متوقع'));
    }
  }
}
