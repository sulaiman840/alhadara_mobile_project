
part of 'sections_cubit.dart';

abstract class SectionsState extends Equatable {
  const SectionsState();
  @override
  List<Object?> get props => [];
}

class SectionsInitial extends SectionsState {}
class SectionsLoading extends SectionsState {}
class SectionsSuccess extends SectionsState {
  final List<SectionModel> sections;
  const SectionsSuccess(this.sections);

  @override
  List<Object?> get props => [sections];
}
class SectionsFailure extends SectionsState {
  final String errorMessage;
  const SectionsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
