import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../data/repositories/quiz_repository.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repo;
  QuizCubit(this._repo) : super(QuizInitial());

  Future<void> fetchQuizzes(int sectionId) async {
    emit(QuizLoading());
    final either = await _repo.fetchQuizzes(sectionId);
    either.fold(
          (l) => emit(QuizError('Failed to load quizzes')),
          (r) => emit(QuizLoaded(r)),
    );
  }

  Future<void> answerOption(int optionId) async {
    emit(QuizLoading());
    final either = await _repo.submitAnswer(optionId);
    either.fold(
          (l) => emit(QuizError('Failed to submit answer')),
          (r) => emit(QuizAnswerResult(r)),
    );
  }
}
