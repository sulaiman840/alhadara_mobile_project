import 'package:equatable/equatable.dart';
import '../data/models/grade_model.dart';

abstract class GradesState extends Equatable {
  const GradesState();
  @override
  List<Object?> get props => [];
}

class GradesInitial extends GradesState {}

class GradesLoading extends GradesState {}

class GradesLoaded extends GradesState {
  final List<GradeModel> grades;
  const GradesLoaded(this.grades);

  @override
  List<Object?> get props => [grades];
}

class GradesError extends GradesState {
  final String errorMessage;
  const GradesError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
