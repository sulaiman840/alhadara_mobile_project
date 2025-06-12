// lib/features/forum/data/repositories/forum_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../datasources/forum_remote_data_source.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';

abstract class ForumRepository {
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId);

  // Changed to return Unit
  Future<Either<StatusRequest, Unit>> postQuestion(int sectionId, String content);
  Future<Either<StatusRequest, Unit>> updateQuestion(int questionId, String content);
  Future<Either<StatusRequest, Unit>> deleteQuestion(int questionId);

  Future<Either<StatusRequest, Unit>> postAnswer(int sectionId, int questionId, String content);
  Future<Either<StatusRequest, Unit>> updateAnswer(int answerId, String content);
  Future<Either<StatusRequest, Unit>> deleteAnswer(int answerId);

  Future<Either<StatusRequest, Unit>> likeQuestion(int questionId);
  Future<Either<StatusRequest, Unit>> unlikeQuestion(int questionId);

  Future<Either<StatusRequest, Unit>> likeAnswer(int answerId);
  Future<Either<StatusRequest, Unit>> unlikeAnswer(int answerId);
}

class ForumRepositoryImpl implements ForumRepository {
  final ForumRemoteDataSource _remote;
  ForumRepositoryImpl(this._remote);

  @override
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId) =>
      _remote.fetchQuestions(sectionId);

  @override
  Future<Either<StatusRequest, Unit>> postQuestion(int sectionId, String content) =>
      _remote.postQuestion(sectionId, content);

  @override
  Future<Either<StatusRequest, Unit>> updateQuestion(int questionId, String content) =>
      _remote.updateQuestion(questionId, content);

  @override
  Future<Either<StatusRequest, Unit>> deleteQuestion(int questionId) =>
      _remote.deleteQuestion(questionId);

  @override
  Future<Either<StatusRequest, Unit>> postAnswer(int sectionId, int questionId, String content) =>
      _remote.postAnswer(sectionId, questionId, content);

  @override
  Future<Either<StatusRequest, Unit>> updateAnswer(int answerId, String content) =>
      _remote.updateAnswer(answerId, content);

  @override
  Future<Either<StatusRequest, Unit>> deleteAnswer(int answerId) =>
      _remote.deleteAnswer(answerId);

  @override
  Future<Either<StatusRequest, Unit>> likeQuestion(int questionId) =>
      _remote.likeQuestion(questionId);

  @override
  Future<Either<StatusRequest, Unit>> unlikeQuestion(int questionId) =>
      _remote.unlikeQuestion(questionId);

  @override
  Future<Either<StatusRequest, Unit>> likeAnswer(int answerId) =>
      _remote.likeAnswer(answerId);

  @override
  Future<Either<StatusRequest, Unit>> unlikeAnswer(int answerId) =>
      _remote.unlikeAnswer(answerId);
}
