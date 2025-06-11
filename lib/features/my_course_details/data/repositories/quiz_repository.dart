import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../datasources/quiz_remote_data_source.dart';
import '../models/quiz_model.dart';

abstract class QuizRepository {
  Future<Either<StatusRequest, List<QuizModel>>> fetchQuizzes(int sectionId);
  Future<Either<StatusRequest, AnswerResponseModel>> submitAnswer(int optionId);
}

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource _remote;
  QuizRepositoryImpl(this._remote);

  @override
  Future<Either<StatusRequest, List<QuizModel>>> fetchQuizzes(int sectionId) =>
      _remote.fetchQuizzes(sectionId);

  @override
  Future<Either<StatusRequest, AnswerResponseModel>> submitAnswer(int optionId) =>
      _remote.submitAnswer(optionId);
}
