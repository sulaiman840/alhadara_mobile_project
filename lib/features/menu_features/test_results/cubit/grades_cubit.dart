import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/models/grade_model.dart';
import '../data/repositories/grades_repository.dart';
import 'grades_state.dart';

class GradesCubit extends Cubit<GradesState> {
  final GradesRepository _repository;

  GradesCubit(this._repository) : super(GradesInitial());

  Future<void> fetchGrades() async {
    emit(GradesLoading());
    try {
      final List<GradeModel> list = await _repository.getMyGrades();
      emit(GradesLoaded(list));
    } on DioException catch (e) {
      String msg = 'حدث خطأ أثناء جلب الدرجات';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          msg = data['message'] as String;
        }
      }
      emit(GradesError(msg));
    } catch (_) {
      emit(const GradesError('حدث خطأ غير متوقع'));
    }
  }
}
