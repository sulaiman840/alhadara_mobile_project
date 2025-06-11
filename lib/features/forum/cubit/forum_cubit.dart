// lib/features/forum/presentation/cubit/forum_cubit.dart

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
          (failure) => emit(const ForumError('Failed to load questions')),
          (questions) => emit(ForumLoaded(questions)),
    );
  }

  Future<void> addQuestion(int sectionId, String title, String content) async {
    emit(ForumLoading());
    final either = await _repo.postQuestion(sectionId, {
      'title': title,
      'content': content,
    });

    if (either.isLeft()) {
      emit(const ForumError('Failed to post question'));
    } else {
      // on success, re-load
      await loadQuestions(sectionId);
    }
  }

  Future<void> removeQuestion(int sectionId, int questionId) async {
    emit(ForumLoading());
    final either = await _repo.deleteQuestion(questionId);

    if (either.isLeft()) {
      emit(const ForumError('Failed to delete question'));
    } else {
      await loadQuestions(sectionId);
    }
  }

  Future<void> addAnswer(int sectionId, int questionId, String content) async {
    emit(ForumLoading());
    final either = await _repo.postAnswer(questionId, {
      'content': content,
    });

    if (either.isLeft()) {
      emit(const ForumError('Failed to post answer'));
    } else {
      await loadQuestions(sectionId);
    }
  }

  Future<void> toggleQuestionLike(int sectionId, int questionId) async {
    // you probably don't want to emit Loading here so the UI doesn't flash
    final either = await _repo.toggleLikeQuestion(questionId);

    if (either.isLeft()) {
      emit(const ForumError('Failed to like/unlike question'));
    } else {
      await loadQuestions(sectionId);
    }
  }

  Future<void> toggleAnswerLike(int sectionId, int answerId) async {
    final either = await _repo.toggleLikeAnswer(answerId);

    if (either.isLeft()) {
      emit(const ForumError('Failed to like/unlike answer'));
    } else {
      await loadQuestions(sectionId);
    }
  }
}
