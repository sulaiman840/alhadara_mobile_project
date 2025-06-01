
import 'package:equatable/equatable.dart';

abstract class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object?> get props => [];
}

class PointsInitial extends PointsState {}

class PointsLoading extends PointsState {}

class PointsSuccess extends PointsState {
  final int points;
  const PointsSuccess(this.points);

  @override
  List<Object?> get props => [points];
}

class PointsFailure extends PointsState {
  final String errorMessage;
  const PointsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
