import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/complaints_repository.dart';
import 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final ComplaintsRepository _repository;
  ComplaintsCubit(this._repository) : super(ComplaintsInitial());

  Future<void> submitComplaint({
    required String description,
    File? file,
  }) async {
    if (description.length < 10) {
      emit(const ComplaintsFailure('complaint_error_short'));
      return;
    }

    emit(ComplaintsLoading());
    try {
      final resp = await _repository.submitComplaint(
        description: description,
        file: file,
      );
      emit(ComplaintsSuccess(resp));
    } on DioException catch (e) {
      var key = 'complaints_error';
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data['messageKey'] is String) {
          key = data['messageKey'] as String;
        }
      }
      emit(ComplaintsFailure(key));
    } catch (_) {
      emit(const ComplaintsFailure('complaints_error'));
    }
  }
}
