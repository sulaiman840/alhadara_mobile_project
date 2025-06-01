// lib/features/auth/cubit/reset_password/reset_password_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/auth_repository.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository _repository;

  ResetPasswordCubit(this._repository) : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required int token,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordLoading());
    try {
      await _repository.resetPassword(
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(const ResetPasswordSuccess("تم إعادة تعيين كلمة المرور بنجاح"));
    }  on DioException catch (e) {
      String msg = 'حدث خطأ أثناء إعادة تعيين كلمة المرور';
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data['message'] is String) msg = data['message'] as String;
      }
      emit(ResetPasswordFailure(msg));
    } catch (e) {
      emit(const ResetPasswordFailure('غير قادر على الاتصال بالخادم. حاول لاحقًا.'));
    }
  }
}
