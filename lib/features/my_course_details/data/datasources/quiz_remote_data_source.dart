import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/quiz_model.dart';

abstract class QuizRemoteDataSource {
  Future<Either<StatusRequest, List<QuizModel>>> fetchQuizzes(int sectionId);
  Future<Either<StatusRequest, AnswerResponseModel>> submitAnswer(int optionId);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final ApiService _api;
  QuizRemoteDataSourceImpl(this._api);

  @override
  Future<Either<StatusRequest, List<QuizModel>>> fetchQuizzes(int sectionId) {
    return _api.get<List<QuizModel>>(
      '/api/quiz/listQuizzesBySectionId/$sectionId',
          (data) {
        final page = data['Quizzes'] as Map<String, dynamic>;
        return (page['data'] as List<dynamic>)
            .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Either<StatusRequest, AnswerResponseModel>> submitAnswer(int optionId) {
    return _api.post<AnswerResponseModel>(
      '/api/quiz/answerQuestion/$optionId',
      {},
          (j) => AnswerResponseModel.fromJson(j as Map<String, dynamic>),
    );
  }
}
