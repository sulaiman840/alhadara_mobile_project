/// lib/features/auth/domain/cubit/verify_state.dart

import 'package:equatable/equatable.dart';

/// All possible states for the verification flow:
abstract class VerifyState extends Equatable {
  const VerifyState();

  @override
  List<Object?> get props => [];
}

/// Initial state (nothing yet):
class VerifyInitial extends VerifyState {}

/// Loading state while request is in progress:
class VerifyLoading extends VerifyState {}

/// Success state (account verified).
class VerifySuccess extends VerifyState {
  final String message; // e.g. "your account has been verified"

  const VerifySuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure state (any DioError).
class VerifyFailure extends VerifyState {
  final String errorMessage;

  const VerifyFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
