import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../data/repositories/auth_repository.dart';
import 'login_state.dart';
import 'package:alhadara_mobile_project/features/auth/data/datasources/auth_remote_data_source.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginCubit(this._repository) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    emit(LoginLoading());
    try {
      final response = await _repository.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );
      final accessToken = response.accessToken.accessToken;
      final user        = response.accessToken.user; // UserModel
      final prefs       = await SharedPreferences.getInstance();

// 1) Save token & ID
      await prefs.setString('access_token', accessToken);
      await prefs.setInt('user_id', user.id);

// 2) Save name & createdAt (unchanged)
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_created_at', user.createdAt);

// 3) Build the full HTTP URL for the photo, then save it
      String photoUrl = '';
      if (user.photo != null && user.photo!.isNotEmpty) {
        // PREPEND your server’s base URL here:
        photoUrl = 'http://192.168.195.198:8000/${user.photo}';
      }
      await prefs.setString('user_photo', photoUrl);
      emit(LoginSuccess(accessToken: accessToken, userId: user.id));
    } on UnverifiedAccountException catch (e) {
      emit(LoginUnverified(e.message));
    } on DioException catch (e) {
      String message = 'Login failed';
      if (e.response != null && e.response?.data != null) {
        final msg = e.response!.data['Message'];
        if (msg is String) message = msg;
      }
      emit(LoginFailure(message));
    } catch (e) {
      emit(const LoginFailure('Unable to connect to server. Try again later.'));
    }
  }
}