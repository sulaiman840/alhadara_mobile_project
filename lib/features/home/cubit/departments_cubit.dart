
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../data/models/department_model.dart';
import '../data/repositories/departments_repository.dart';
import 'departments_state.dart';

class DepartmentsCubit extends Cubit<DepartmentsState> {
  final DepartmentsRepository _repository;

  DepartmentsCubit(this._repository) : super(DepartmentsInitial());

  /// Fetch all departments and emit appropriate states.
  Future<void> fetchDepartments() async {
    emit(DepartmentsLoading());
    try {
      final list = await _repository.fetchAllDepartments();
      emit(DepartmentsSuccess(list));
    } on DioException catch (e) {
      String msg = 'حدث خطأ أثناء جلب الأقسام';
      if (e.response?.data is Map<String, dynamic>) {
        final raw = e.response!.data as Map<String, dynamic>;
        if (raw.containsKey('message') && raw['message'] is String) {
          msg = raw['message'] as String;
        }
      }
      emit(DepartmentsFailure(msg));
    } catch (_) {
      emit(const DepartmentsFailure('حدث خطأ غير متوقع'));
    }
  }
}
