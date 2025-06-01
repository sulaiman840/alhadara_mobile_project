
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String accessToken;
  final int userId;

  const LoginSuccess({
    required this.accessToken,
    required this.userId,
  });

  @override
  List<Object?> get props => [accessToken, userId];
}

class LoginUnverified extends LoginState {
  final String message;

  const LoginUnverified(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
