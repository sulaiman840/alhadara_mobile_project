// lib/features/auth/cubit/forgot_password_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alhadara_mobile_project/features/auth/data/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _repository;

  ForgotPasswordCubit(this._repository) : super(ForgotPasswordInitial());

  Future<void> forgotPassword({
    required String email,
  }) async {
    emit(ForgotPasswordLoading());

    try {
      await _repository.forgotPassword(email: email);
      emit(ForgotPasswordSuccess("تم إرسال رمز التحقق بنجاح"));
    } on Exception catch (e) {
      String message = 'حدث خطأ أثناء إرسال رمز التحقق';
      if (e is DioException && e.response?.data != null) {
        final raw = e.response!.data;
        if (raw is Map<String, dynamic> && raw.containsKey('mes')) {
          message = raw['mes'] as String;
        }
      }
      emit(ForgotPasswordFailure(message));
    }
  }
}
