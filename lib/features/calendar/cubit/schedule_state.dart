import 'package:equatable/equatable.dart';
import '../data/models/schedule_event_model.dart';

abstract class ScheduleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleEventModel> events;
  ScheduleLoaded(this.events);
  @override
  List<Object?> get props => [events];
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
  @override
  List<Object?> get props => [message];
}
