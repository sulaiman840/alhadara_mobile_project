import 'package:equatable/equatable.dart';

import '../data/models/question_model.dart';

/// A simple union‐style state for all of your forum operations.
abstract class ForumState extends Equatable {
  const ForumState();
  @override
  List<Object?> get props => [];
}

class ForumInitial extends ForumState {}

/// Emitted when any operation is in progress (you could split this if you want).
class ForumLoading extends ForumState {}

/// Emitted when the list of questions is available.
class ForumLoaded extends ForumState {
  final List<QuestionModel> questions;
  const ForumLoaded(this.questions);
  @override
  List<Object?> get props => [questions];
}

/// Emitted on *any* failure.  In a real app you might have more fine‐grained errors.
class ForumError extends ForumState {
  final String message;
  const ForumError(this.message);
  @override
  List<Object?> get props => [message];
}
