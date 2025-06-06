import '../datasources/my_courses_remote_data_source.dart';
import '../models/enrolled_course_model.dart';

abstract class MyCoursesRepository {
  Future<List<EnrolledCourseModel>> fetchMyCourses();
}

class MyCoursesRepositoryImpl implements MyCoursesRepository {
  final MyCoursesRemoteDataSource _remoteDataSource;
  MyCoursesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<EnrolledCourseModel>> fetchMyCourses() {
    return _remoteDataSource.getMyCourses();
  }
}