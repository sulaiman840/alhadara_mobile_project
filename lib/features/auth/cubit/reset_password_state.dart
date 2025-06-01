// lib/features/auth/cubit/reset_password/reset_password_state.dart

import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String errorMessage;
  const ResetPasswordFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
