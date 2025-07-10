import 'package:equatable/equatable.dart';
import '../data/models/search_course_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final SearchCourseModel result;
  const SearchSuccess(this.result);
  @override
  List<Object?> get props => [result];
}
class SearchFailure extends SearchState {
  final String errorMessage;
  const SearchFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
