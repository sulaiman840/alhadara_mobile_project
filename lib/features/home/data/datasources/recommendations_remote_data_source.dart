
import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/recommended_course_model.dart';

abstract class RecommendationsRemoteDataSource {
  Future<Either<StatusRequest, RecommendedCoursesResponse>> fetchRecommendations();
}

class RecommendationsRemoteDataSourceImpl implements RecommendationsRemoteDataSource {
  final ApiService _api;
  RecommendationsRemoteDataSourceImpl(this._api);

  @override
  Future<Either<StatusRequest, RecommendedCoursesResponse>> fetchRecommendations() {
    return _api.get(
      'api/student/recommendations',
          (json) => RecommendedCoursesResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
