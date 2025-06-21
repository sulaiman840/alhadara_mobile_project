import '../datasources/saved_courses_remote_data_source.dart';
import '../model/saved_course_model.dart';

abstract class SavedCoursesRepository {
  Future<List<SavedCourse>> getSavedCourses(int perPage);
  Future<int> getSavedCount();
  Future<void> addToSaved(int courseId);
  Future<void> removeFromSaved(int courseId);
}

class SavedCoursesRepositoryImpl implements SavedCoursesRepository {
  final SavedCoursesRemoteDataSource _remote;
  SavedCoursesRepositoryImpl(this._remote);

  @override
  Future<List<SavedCourse>> getSavedCourses(int perPage) =>
      _remote.fetchSavedCourses(perPage: perPage);

  @override
  Future<int> getSavedCount() =>
      _remote.fetchSavedCount();

  @override
  Future<void> addToSaved(int courseId) =>
      _remote.saveCourse(courseId);

  @override
  Future<void> removeFromSaved(int courseId) =>
      _remote.unsaveCourse(courseId);
}
