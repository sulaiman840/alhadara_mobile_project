
import 'package:equatable/equatable.dart';
import '../data/models/section_file_model.dart';

abstract class SectionFilesState extends Equatable {
  const SectionFilesState();
  @override List<Object?> get props => [];
}

class SectionFilesLoading extends SectionFilesState {}
class SectionFilesLoaded extends SectionFilesState {
  final List<SectionFile> files;
  const SectionFilesLoaded(this.files);
  @override List<Object?> get props => [files];
}
class SectionFilesError extends SectionFilesState {
  final String message;
  const SectionFilesError(this.message);
  @override List<Object?> get props => [message];
}
