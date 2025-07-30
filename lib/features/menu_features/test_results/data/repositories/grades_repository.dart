import 'package:dio/dio.dart';
import '../datasources/grades_remote_data_source.dart';
import '../models/grade_model.dart';

class GradesRepository {
  final GradesRemoteDataSource _remote;

  GradesRepository(this._remote);

  Future<List<GradeModel>> getMyGrades() {
    return _remote.fetchMyGrades();
  }
}
