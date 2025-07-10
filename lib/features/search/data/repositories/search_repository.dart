import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/search_course_model.dart';

abstract class SearchRepository {
  Future<Either<StatusRequest, SearchCourseModel>> searchCourses(String query);
}

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _ds;
  SearchRepositoryImpl(this._ds);

  @override
  Future<Either<StatusRequest, SearchCourseModel>> searchCourses(String query) =>
      _ds.searchCourses(query);
}
