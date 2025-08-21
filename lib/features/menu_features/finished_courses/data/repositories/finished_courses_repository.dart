import '../datasources/finished_courses_remote_data_source.dart';
import '../models/finished_course_model.dart';

abstract class FinishedCoursesRepository {
  Future<List<FinishedCourseModel>> getFinishedCourses();
}

class FinishedCoursesRepositoryImpl implements FinishedCoursesRepository {
  final FinishedCoursesRemoteDataSource _remote;
  FinishedCoursesRepositoryImpl(this._remote);

  @override
  Future<List<FinishedCourseModel>> getFinishedCourses() {
    return _remote.fetchFinished();
  }
}
