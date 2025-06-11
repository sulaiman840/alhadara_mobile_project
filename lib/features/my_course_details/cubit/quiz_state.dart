import 'package:equatable/equatable.dart';

import '../data/models/quiz_model.dart';


abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizModel> quizzes;
  const QuizLoaded(this.quizzes);
  @override
  List<Object?> get props => [quizzes];
}

class QuizAnswerResult extends QuizState {
  final AnswerResponseModel result;
  const QuizAnswerResult(this.result);
  @override
  List<Object?> get props => [result];
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);
  @override
  List<Object?> get props => [message];
}
