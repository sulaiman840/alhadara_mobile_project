
import 'package:equatable/equatable.dart';
import '../data/models/grade_model.dart';

abstract class GradesState extends Equatable {
  const GradesState();
  @override
  List<Object?> get props => [];
}

/// Idle / “haven’t started fetching yet”
class GradesInitial extends GradesState {}

/// While the request is in progress
class GradesLoading extends GradesState {}

/// On success, carries a list of GradeModel
class GradesLoaded extends GradesState {
  final List<GradeModel> grades;
  const GradesLoaded(this.grades);

  @override
  List<Object?> get props => [grades];
}

/// On failure
class GradesError extends GradesState {
  final String errorMessage;
  const GradesError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
