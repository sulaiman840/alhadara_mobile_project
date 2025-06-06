import 'package:equatable/equatable.dart';
import '../data/models/trainer_with_course_model.dart';

abstract class TrainersState extends Equatable {
  const TrainersState();
  @override List<Object?> get props => [];
}

class TrainersLoading extends TrainersState {}
class TrainersLoaded extends TrainersState {
  final List<TrainerWithCourse> trainers;
  const TrainersLoaded(this.trainers);
  @override List<Object?> get props => [trainers];
}
class TrainersError extends TrainersState {
  final String message;
  const TrainersError(this.message);
  @override List<Object?> get props => [message];
}
