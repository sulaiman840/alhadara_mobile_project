
import 'package:equatable/equatable.dart';
import '../data/models/complaint_model.dart';

abstract class ComplaintsState extends Equatable {
  const ComplaintsState();
  @override
  List<Object?> get props => [];
}

class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

class ComplaintsSuccess extends ComplaintsState {
  final ComplaintResponse response;
  const ComplaintsSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ComplaintsFailure extends ComplaintsState {
  final String errorMessage;
  const ComplaintsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
