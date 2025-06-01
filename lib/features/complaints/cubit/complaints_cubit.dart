
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/complaints_repository.dart';
import 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final ComplaintsRepository _repository;
  ComplaintsCubit(this._repository) : super(ComplaintsInitial());

  /// description must be at least 10 characters.
  Future<void> submitComplaint({
    required String description,
    File? file,
  }) async {
    if (description.length < 10) {
      emit(const ComplaintsFailure('يجب أن تكون الشكوى 10 أحرف على الأقل.'));
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
      String message = 'حدث خطأ أثناء إرسال الشكوى';
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data.containsKey('message') && data['message'] is String) {
          message = data['message'] as String;
        }
      }
      emit(ComplaintsFailure(message));
    } catch (_) {
      emit(const ComplaintsFailure('حدث خطأ غير متوقع.'));
    }
  }
}
