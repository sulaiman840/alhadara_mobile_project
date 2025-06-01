// lib/features/auth/cubit/forgot_password_state.dart

import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  const ForgotPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String errorMessage;
  const ForgotPasswordFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
