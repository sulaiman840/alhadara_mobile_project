import 'package:dartz/dartz.dart';

import '../../../../core/network/statusrequest.dart';
import '../datasources/forum_remote_data_source.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';

/// The interface your Cubit will talk to.
abstract class ForumRepository {
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId);
  Future<Either<StatusRequest, QuestionModel>> postQuestion(
      int sectionId,
      Map<String, dynamic> body,
      );
  Future<Either<StatusRequest, Unit>> deleteQuestion(int questionId);
  Future<Either<StatusRequest, AnswerModel>> postAnswer(
      int questionId,
      Map<String, dynamic> body,
      );
  Future<Either<StatusRequest, bool>> toggleLikeQuestion(int questionId);
  Future<Either<StatusRequest, bool>> toggleLikeAnswer(int answerId);
}

/// A very thin implementation that just delegates to your remote data source.
class ForumRepositoryImpl implements ForumRepository {
  final ForumRemoteDataSource _remote;
  ForumRepositoryImpl(this._remote);

  @override
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId) =>
      _remote.fetchQuestions(sectionId);

  @override
  Future<Either<StatusRequest, QuestionModel>> postQuestion(
      int sectionId,
      Map<String, dynamic> body,
      ) =>
      _remote.postQuestion(sectionId, body);

  @override
  Future<Either<StatusRequest, Unit>> deleteQuestion(int questionId) =>
      _remote.deleteQuestion(questionId);

  @override
  Future<Either<StatusRequest, AnswerModel>> postAnswer(
      int questionId,
      Map<String, dynamic> body,
      ) =>
      _remote.postAnswer(questionId, body);

  @override
  Future<Either<StatusRequest, bool>> toggleLikeQuestion(int questionId) =>
      _remote.toggleLikeQuestion(questionId);

  @override
  Future<Either<StatusRequest, bool>> toggleLikeAnswer(int answerId) =>
      _remote.toggleLikeAnswer(answerId);
}
