
import 'user_model.dart';

class LoginResponseModel {
  final String message;
  final _AccessToken accessToken;

  LoginResponseModel({
    required this.message,
    required this.accessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['Message'] as String,
      accessToken: _AccessToken.fromJson(json['AccessToken'] as Map<String, dynamic>),
    );
  }
}

class _AccessToken {
  final String accessToken;
  final String tokenType;
  final UserModel user;

  _AccessToken({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory _AccessToken.fromJson(Map<String, dynamic> json) {
    return _AccessToken(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
