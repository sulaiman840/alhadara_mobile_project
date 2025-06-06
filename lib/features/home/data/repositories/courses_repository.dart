
import '../datasources/courses_remote_data_source.dart';
import '../models/course_model.dart';

abstract class CoursesRepository {
  Future<List<CourseModel>> fetchCoursesByDepartment(int departmentId);
}

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource _remoteDataSource;
  CoursesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CourseModel>> fetchCoursesByDepartment(int departmentId) {
    return _remoteDataSource.getCoursesByDepartment(departmentId);
  }
}
