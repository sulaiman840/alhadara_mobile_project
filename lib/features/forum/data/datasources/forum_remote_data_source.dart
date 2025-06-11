// lib/features/forum/data/datasources/forum_remote_data_source.dart

import 'package:dartz/dartz.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';
import '../models/like_model.dart';

abstract class ForumRemoteDataSource {
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId);
  Future<Either<StatusRequest, QuestionModel>> postQuestion(int sectionId, Map<String, dynamic> body);
  Future<Either<StatusRequest, Unit>> deleteQuestion(int questionId);
  Future<Either<StatusRequest, AnswerModel>> postAnswer(int questionId, Map<String, dynamic> body);
  Future<Either<StatusRequest, bool>> toggleLikeQuestion(int questionId);
  Future<Either<StatusRequest, List<LikeModel>>> fetchQuestionLikes(int questionId);
  Future<Either<StatusRequest, bool>> toggleLikeAnswer(int answerId);
  Future<Either<StatusRequest, List<LikeModel>>> fetchAnswerLikes(int questionId);
}

class ForumRemoteDataSourceImpl implements ForumRemoteDataSource {
  final ApiService _api;
  ForumRemoteDataSourceImpl(this._api);

  @override
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId) {
    return _api.get<List<QuestionModel>>(
      '/api/forum/sections/$sectionId/questions',
          (data) => (data as List)
          .map((j) => QuestionModel.fromJson(j as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Either<StatusRequest, QuestionModel>> postQuestion(int sectionId, Map<String, dynamic> body) {
    return _api.post<QuestionModel>(
      '/api/forum/sections/$sectionId/questions',
      body,
          (j) => QuestionModel.fromJson(j as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> deleteQuestion(int questionId) {
    return _api.delete<Unit>(
      '/api/forum/questions/$questionId',
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, AnswerModel>> postAnswer(int questionId, Map<String, dynamic> body) {
    return _api.post<AnswerModel>(
      '/api/forum/questions/$questionId/answers',
      body,
          (j) => AnswerModel.fromJson(j as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<StatusRequest, bool>> toggleLikeQuestion(int questionId) {
    return _api.post<bool>(
      '/api/forum/questions/$questionId/like',
      {},
          (j) => (j as Map<String, dynamic>)['is_liked'] as bool,
    );
  }

  @override
  Future<Either<StatusRequest, List<LikeModel>>> fetchQuestionLikes(int questionId) {
    return _api.get<List<LikeModel>>(
      '/api/forum/questions/$questionId/likes',
          (data) => (data as List)
          .map((j) => LikeModel.fromJson(j as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Either<StatusRequest, bool>> toggleLikeAnswer(int answerId) {
    return _api.post<bool>(
      '/api/forum/answers/$answerId/like',
      {},
          (j) => (j as Map<String, dynamic>)['is_liked'] as bool,
    );
  }

  @override
  Future<Either<StatusRequest, List<LikeModel>>> fetchAnswerLikes(int questionId) {
    return _api.get<List<LikeModel>>(
      '/api/forum/questions/$questionId/answer-likes',
          (data) => (data as List)
          .map((j) => LikeModel.fromJson(j as Map<String, dynamic>))
          .toList(),
    );
  }
}
