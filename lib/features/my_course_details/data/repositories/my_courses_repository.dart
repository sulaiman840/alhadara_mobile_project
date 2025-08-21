import '../datasources/my_courses_remote_data_source.dart';
import '../models/enrolled_course_model.dart';

abstract class MyCoursesRepository {
  Future<MyCoursesPageResult> fetchMyCourses({int page, int perPage});

  Future<EnrolledCourseModel?> findEnrollmentByCourseId(
      int courseId, {
        int perPage,
        int maxPages,
      });
}

class MyCoursesRepositoryImpl implements MyCoursesRepository {
  final MyCoursesRemoteDataSource _remoteDataSource;
  MyCoursesRepositoryImpl(this._remoteDataSource);

  @override
  Future<MyCoursesPageResult> fetchMyCourses({int page = 1, int perPage = 10}) {
    return _remoteDataSource.getMyCourses(page: page, perPage: perPage);
  }

  @override
  Future<EnrolledCourseModel?> findEnrollmentByCourseId(
      int courseId, {
        int perPage = 50,
        int maxPages = 100,
      }) async {
    int page = 1;
    int lastPage = 1;

    do {
      final res = await _remoteDataSource.getMyCourses(page: page, perPage: perPage);
      for (final e in res.items) {
        if (e.course.id == courseId) return e;
      }
      lastPage = res.lastPage;
      page++;
    } while (page <= lastPage && page <= maxPages);

    return null;
  }
}
