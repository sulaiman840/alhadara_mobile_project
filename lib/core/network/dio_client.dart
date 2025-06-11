import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/const.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ConstString.baseURl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. Retrieve the token from SharedPreferences (if available)
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');

          // 2. If the token exists, add it to the Authorization header
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // 3. Continue with the request
          handler.next(options);
        },
        onResponse: (response, handler) {
          // You could also check for 401 here and attempt a refresh, etc.
          handler.next(response);
        },
        onError: (DioException error, handler) {
          // Optionally handle errors (e.g. token expired → redirect to login)
          handler.next(error);
        },
      ),
    );
  }
}
