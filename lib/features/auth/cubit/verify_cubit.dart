/// lib/features/auth/domain/cubit/verify_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/auth_repository.dart';
import 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  final AuthRepository _repository;

  VerifyCubit(this._repository) : super(VerifyInitial());

  /// Call this to send the 5-digit token to the server.
  Future<void> verifyAccount({ required int token }) async {
    emit(VerifyLoading());
    try {
      final response = await _repository.verifyEmail(token: token);
      // On success (HTTP 200), emit success with message:
      emit(VerifySuccess(response.message));
    } on DioException catch (e) {
      // If server returned 422 or other status, attempt to parse e.response.data['Message']:
      String message = 'فشل التحقق. حاول مرة أخرى.';
      if (e.response != null && e.response?.data != null) {
        final msg = e.response!.data['Message'];
        if (msg is String) message = msg;
      }
      emit(VerifyFailure(message));
    } catch (e) {
      emit(const VerifyFailure('غير قادر على الاتصال بالخادم. حاول لاحقًا.'));
    }
  }
}
