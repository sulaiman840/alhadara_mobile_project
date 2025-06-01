import 'package:dio/dio.dart';
import 'package:alhadara_mobile_project/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:alhadara_mobile_project/features/auth/data/models/login_response_model.dart';
import 'package:alhadara_mobile_project/features/auth/data/models/verification_response_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);


  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String fcmToken,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
  }

  Future<String> logout() {
    return remoteDataSource.logout();
  }
  Future<VerificationResponseModel> verifyEmail({ required int token }) {
    return remoteDataSource.verifyEmail(token: token);
  }
  // ────────────────────────────────────────────────────────────────────────────
  // Expose forgotPassword & resetPassword
  Future<String> forgotPassword({
    required String email,
  }) {
    return remoteDataSource.forgotPassword(email: email);
  }

  Future<String> resetPassword({
    required int token,
    required String password,
    required String passwordConfirmation,
  }) {
    return remoteDataSource.resetPassword(
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

}
