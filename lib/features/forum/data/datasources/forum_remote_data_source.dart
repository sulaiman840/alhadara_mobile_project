// lib/features/forum/data/datasources/forum_remote_data_source.dart

import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';

abstract class ForumRemoteDataSource {
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId);

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

class ForumRemoteDataSourceImpl implements ForumRemoteDataSource {
  final ApiService _api;
  ForumRemoteDataSourceImpl(this._api);

  @override
  Future<Either<StatusRequest, List<QuestionModel>>> fetchQuestions(int sectionId) {
    return _api.get<List<QuestionModel>>(
      '/api/forum/sections/$sectionId/questions',
          (data) => (data['data'] as List)
          .map((j) => QuestionModel.fromJson(j as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> postQuestion(int sectionId, String content) {
    return _api.post<Unit>(
      '/api/forum/questions',
      {
        'content': content,
        'course_section_id': sectionId,
      },
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> updateQuestion(int questionId, String content) {
    return _api.put<Unit>(
      '/api/forum/questions/$questionId',
      {'content': content},
          (_) => unit,
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
  Future<Either<StatusRequest, Unit>> postAnswer(int sectionId, int questionId, String content) {
    return _api.post<Unit>(
      '/api/forum/answers',
      {
        'content': content,
        'question_id': questionId,
        'course_section_id': sectionId,
      },
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> updateAnswer(int answerId, String content) {
    return _api.put<Unit>(
      '/api/forum/answers/$answerId',
      {'content': content},
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> deleteAnswer(int answerId) {
    return _api.delete<Unit>(
      '/api/forum/answers/$answerId',
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> likeQuestion(int questionId) {
    return _api.post<Unit>(
      '/api/forum/questions/$questionId/like',
      {},
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> unlikeQuestion(int questionId) {
    return _api.delete<Unit>(
      '/api/forum/questions/$questionId/like',
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> likeAnswer(int answerId) {
    return _api.post<Unit>(
      '/api/forum/answers/$answerId/like',
      {},
          (_) => unit,
    );
  }

  @override
  Future<Either<StatusRequest, Unit>> unlikeAnswer(int answerId) {
    return _api.delete<Unit>(
      '/api/forum/answers/$answerId/like',
          (_) => unit,
    );
  }
}
