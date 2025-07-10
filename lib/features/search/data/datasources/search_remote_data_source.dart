import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/search_course_model.dart';

abstract class SearchRemoteDataSource {
  Future<Either<StatusRequest, SearchCourseModel>> searchCourses(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiService _api;
  SearchRemoteDataSourceImpl(this._api);

  @override
  Future<Either<StatusRequest, SearchCourseModel>> searchCourses(String q) {
    return _api.get(
      'api/student/searchCourses/$q',
          (json) => SearchCourseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
