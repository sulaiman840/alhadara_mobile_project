
import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../datasources/recommendations_remote_data_source.dart';
import '../models/recommended_course_model.dart';

abstract class RecommendationsRepository {
  Future<Either<StatusRequest, RecommendedCoursesResponse>> getRecommendations();
}

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsRemoteDataSource _ds;
  RecommendationsRepositoryImpl(this._ds);

  @override
  Future<Either<StatusRequest, RecommendedCoursesResponse>> getRecommendations() =>
      _ds.fetchRecommendations();
}
