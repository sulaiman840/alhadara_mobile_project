
import 'package:equatable/equatable.dart';
import '../data/models/department_model.dart';

abstract class DepartmentsState extends Equatable {
  const DepartmentsState();

  @override
  List<Object?> get props => [];
}

class DepartmentsInitial extends DepartmentsState {}

class DepartmentsLoading extends DepartmentsState {}

class DepartmentsSuccess extends DepartmentsState {
  final List<DepartmentModel> departments;
  const DepartmentsSuccess(this.departments);

  @override
  List<Object?> get props => [departments];
}

class DepartmentsFailure extends DepartmentsState {
  final String errorMessage;
  const DepartmentsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
