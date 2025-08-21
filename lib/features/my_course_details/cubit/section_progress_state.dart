import 'package:equatable/equatable.dart';

abstract class SectionProgressState extends Equatable {
  const SectionProgressState();
  @override
  List<Object?> get props => [];
}

class SectionProgressInitial extends SectionProgressState {}

class SectionProgressLoading extends SectionProgressState {}

class SectionProgressSuccess extends SectionProgressState {
  final int progress; 
  const SectionProgressSuccess(this.progress);

  @override
  List<Object?> get props => [progress];
}

class SectionProgressFailure extends SectionProgressState {
  final String message;
  const SectionProgressFailure(this.message);

  @override
  List<Object?> get props => [message];
}
