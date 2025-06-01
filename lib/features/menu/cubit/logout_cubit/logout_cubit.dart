import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../auth/data/repositories/auth_repository.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _repository;

  LogoutCubit(this._repository) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      print('➡️ [LogoutCubit] Starting logout()');
      await _repository.logout();
      print('✅ [LogoutCubit] Server logout succeeded');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('user_id');
      print('🔒 [LogoutCubit] Cleared SharedPreferences.');

      // تصدير رسالة عربية ثابتة هنا:
      emit(const LogoutSuccess('تم تسجيل الخروج بنجاح'));
    } on DioException catch (e) {
      print('❌ [LogoutCubit] DioException: ${e.toString()}');
      String message = 'حدث خطأ أثناء تسجيل الخروج';
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data['message'] is String) {
          message = data['message'] as String;
        }
      }
      emit(LogoutFailure(message));
    } catch (e) {
      print('❌ [LogoutCubit] Unexpected exception: $e');
      emit(const LogoutFailure('غير قادر على الاتصال بالخادم. حاول لاحقًا.'));
    }
  }
}
