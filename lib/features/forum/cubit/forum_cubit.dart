
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/statusrequest.dart';
import '../data/repositories/forum_repository.dart';
import 'forum_state.dart';

class ForumCubit extends Cubit<ForumState> {
  final ForumRepository _repo;
  ForumCubit(this._repo) : super(ForumInitial());

  Future<void> loadQuestions(int sectionId) async {
    emit(ForumLoading());
    final either = await _repo.fetchQuestions(sectionId);
    either.fold(
          (_)       => emit(const ForumError('Failed to load questions')),
          (qs)      => emit(ForumLoaded(qs)),
    );
  }

  Future<void> addQuestion(int sectionId, String content) async {
    emit(ForumLoading());
    final either = await _repo.postQuestion(sectionId, content);
    if (either.isLeft()) {
      emit(const ForumError('Failed to post question'));
      return;
    }
    await loadQuestions(sectionId);
  }

  Future<void> updateQuestion(int sectionId, int questionId, String content) async {
    emit(ForumLoading());
    final either = await _repo.updateQuestion(questionId, content);
    if (either.isLeft()) {
      emit(const ForumError('Failed to update question'));
      return;
    }
    await loadQuestions(sectionId);
  }

  Future<void> removeQuestion(int sectionId, int questionId) async {
    emit(ForumLoading());
    final either = await _repo.deleteQuestion(questionId);
    if (either.isLeft()) {
      emit(const ForumError('Failed to delete question'));
      return;
    }
    await loadQuestions(sectionId);
  }

  Future<void> addAnswer(int sectionId, int questionId, String content) async {
    emit(ForumLoading());
    final either = await _repo.postAnswer(sectionId, questionId, content);
    if (either.isLeft()) {
      emit(const ForumError('Failed to post answer'));
      return;
    }
    await loadQuestions(sectionId);
  }

  Future<void> updateAnswer(int sectionId, int answerId, String content) async {
    emit(ForumLoading());
    final either = await _repo.updateAnswer(answerId, content);
    if (either.isLeft()) {
      emit(const ForumError('Failed to update answer'));
      return;
    }
    await loadQuestions(sectionId);
  }

  Future<void> removeAnswer(int sectionId, int answerId) async {
    emit(ForumLoading());
    final either = await _repo.deleteAnswer(answerId);
    if (either.isLeft()) {
      emit(const ForumError('Failed to delete answer'));
      return;
    }
    await loadQuestions(sectionId);
  }

  Future<void> toggleQuestionLike(int sectionId, int questionId, bool liked) async {
    final either = liked
        ? await _repo.unlikeQuestion(questionId)
        : await _repo.likeQuestion(questionId);

    if (either.isLeft()) {
      emit(const ForumError('Failed to toggle question like'));
      return;
    }
    await loadQuestions(sectionId);
  }

  Future<void> toggleAnswerLike(int sectionId, int answerId, bool liked) async {
    final either = liked
        ? await _repo.unlikeAnswer(answerId)
        : await _repo.likeAnswer(answerId);

    if (either.isLeft()) {
      emit(const ForumError('Failed to toggle answer like'));
      return;
    }
    await loadQuestions(sectionId);
  }
}
