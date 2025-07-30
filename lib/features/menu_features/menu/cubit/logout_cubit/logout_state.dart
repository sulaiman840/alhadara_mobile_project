import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

/// Idle
class LogoutInitial extends LogoutState {}

/// Loading indicator
class LogoutLoading extends LogoutState {}

/// On success, we carry the “message” from the server
class LogoutSuccess extends LogoutState {
  final String message;
  const LogoutSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// On failure
class LogoutFailure extends LogoutState {
  final String errorMessage;
  const LogoutFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
