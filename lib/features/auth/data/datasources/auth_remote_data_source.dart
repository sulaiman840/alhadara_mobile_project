
import 'package:dio/dio.dart';
import 'package:alhadara_mobile_project/features/auth/data/models/login_response_model.dart';
import 'package:alhadara_mobile_project/features/auth/data/models/verification_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final path = 'api/auth/student/login';
    print("🌐 [AuthRemoteDataSource] POST → ${_dio.options.baseUrl}$path");
    print("🌐 [AuthRemoteDataSource] Body → { email: $email, password: $password, fcm_token: $fcmToken }");

    try {
      final response = await _dio.post(path, data: {
        "email": email,
        "password": password,
        "fcm_token": fcmToken,
      });

      print("🌐 [AuthRemoteDataSource] Received status code: ${response.statusCode}");
      print("🌐 [AuthRemoteDataSource] Response data: ${response.data}");

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final serverMsg = (e.response!.data['Message'] as String);
        print("🌐 [AuthRemoteDataSource] 422 Unverified: $serverMsg");
        throw UnverifiedAccountException(serverMsg);
      }
      print("🌐 [AuthRemoteDataSource] DioException (other than 422): ${e.toString()}");
      rethrow;
    }
  }

  /// Verification endpoint
  ///
  /// token: the integer code the user received via email/SMS.
  Future<VerificationResponseModel> verifyEmail({ required int token }) async {
    final path = 'api/auth/student/verificationEmail';
    try {
      final response = await _dio.post(path, data: {
        "token": token,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerificationResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      // Any other unexpected status:
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      // For simplicity, any DioError is rethrown; we’ll show a generic error in UI.
      rethrow;
    }
  }

  Future<String> logout() async {
    // Note: we assume the DioClient is already configured to attach the "Authorization: Bearer <token>" header
    // You might need to set it manually if not.
    final path = 'api/auth/student/logout';

    try {
      final response = await _dio.post(path);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // The JSON is: { "message": "User successfully signed out" }
        final data = response.data;
        if (data is Map<String, dynamic> && data['message'] is String) {
          return data['message'] as String;
        }
        return 'تم تسجيل الخروج بنجاح'; // fallback message in Arabic
      }
      // any non‐200/201: throw so repository can catch
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      // rethrow for repository to catch
      rethrow;
    }
  }
  // ─────────────────────────────────────────────────────────────────────────────
  // 1) FORGOT PASSWORD
  Future<String> forgotPassword({
    required String email,
  }) async {
    final path = 'api/auth/student/forgotPassword';
    print("🌐 [AuthRemoteDataSource] POST → ${_dio.options.baseUrl}$path");
    print("🌐 [AuthRemoteDataSource] Body → { email: $email }");

    try {
      final response = await _dio.post(path, data: {"email": email});
      print("🌐 [AuthRemoteDataSource] Status code: ${response.statusCode}");
      print("🌐 [AuthRemoteDataSource] Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('mes') && data['mes'] is String) {
          return data['mes'] as String;
        }
        return 'تمّ إرسال رمز التحقق بنجاح';
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      // PRINT the entire exception (including any HTTP status or message)
      print("‼️ [AuthRemoteDataSource] DioException in forgotPassword ❌");
      print("   Message: ${e.message}");
      if (e.response != null) {
        print("   HTTP status code: ${e.response?.statusCode}");
        print("   Response data  : ${e.response?.data}");
      }
      rethrow;
    } catch (e, stack) {
      // In case some other exception is thrown (unlikely, but just in case)
      print("‼️ [AuthRemoteDataSource] Unexpected exception in forgotPassword ❌");
      print("   $e");
      print(stack);
      rethrow;
    }
  }

  // 2) RESET PASSWORD
  Future<String> resetPassword({
    required int token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final path = 'api/auth/student/passwordReset';
    print("🌐 [AuthRemoteDataSource] POST → ${_dio.options.baseUrl}$path");
    print("🌐 [AuthRemoteDataSource] Body → { token: $token, password: $password, password_confirmation: $passwordConfirmation }");

    try {
      final response = await _dio.post(path, data: {
        "token": token,
        "password": password,
        "password_confirmation": passwordConfirmation,
      });
      print("🌐 [AuthRemoteDataSource] resetPassword status: ${response.statusCode}");
      print("🌐 [AuthRemoteDataSource] resetPassword data: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['message'] is String) {
          return data['message'] as String;
        }
        return 'تم إعادة تعيين كلمة المرور بنجاح';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }


}

/// Custom exception to indicate “account not verified” (HTTP 422)
class UnverifiedAccountException implements Exception {
  final String message;
  UnverifiedAccountException(this.message);
  @override
  String toString() => 'UnverifiedAccountException: $message';
}
