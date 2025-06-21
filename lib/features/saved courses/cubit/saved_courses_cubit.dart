// lib/features/saved_courses/cubit/saved_courses_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import '../../home/data/models/course_model.dart';
import '../../my_course_details/data/models/enrolled_course_model.dart';
import '../../my_course_details/data/repositories/my_courses_repository.dart';
import '../data/model/saved_course_model.dart';
import '../data/repositories/saved_courses_repository.dart';
import 'saved_courses_state.dart';

class SavedCoursesCubit extends Cubit<SavedCoursesState> {
  final SavedCoursesRepository _savedRepo;
  final MyCoursesRepository _myCoursesRepo;

  // cache last-loaded
  List<SavedCourse> _cachedCourses = [];
  int _cachedCount = 0;

  SavedCoursesCubit(this._savedRepo, this._myCoursesRepo)
      : super(SavedCoursesLoading());

  Future<void> fetchSaved() async {
    try {
      emit(SavedCoursesLoading());
      final courses = await _savedRepo.getSavedCourses(10);
      final count = await _savedRepo.getSavedCount();
      // update cache
      _cachedCourses = courses;
      _cachedCount = count;
      emit(SavedCoursesLoaded(courses, count));
    } catch (_) {
      emit(const SavedCoursesError('فشل في جلب الكورسات المحفوظة'));
    }
  }

  Future<void> toggleSaved(int courseId, bool currentlySaved) async {
    try {
      if (currentlySaved) {
        await _savedRepo.removeFromSaved(courseId);
      } else {
        await _savedRepo.addToSaved(courseId);
      }
      await fetchSaved();
    } catch (_) {
      // ignore or emit error
    }
  }

  Future<void> selectCourse(SavedCourse c) async {
    // 1) fetch enrolled
    List<EnrolledCourseModel> enrolled;
    try {
      enrolled = await _myCoursesRepo.fetchMyCourses();
    } catch (_) {
      enrolled = [];
    }
    final match = enrolled.firstWhereOrNull((e) => e.course.id == c.id);

    // 2) map to CourseModel
    final courseModel = CourseModel(
      id: c.id,
      name: c.name,
      description: c.description,
      photo: c.photo,
      departmentId: c.departmentId,
      createdAt: c.createdAt,
      updatedAt: c.updatedAt,
    );

    // 3) emit Navigate
    emit(SavedCoursesNavigate(
      isEnrolled: match != null,
      courseModel: courseModel,
      enrolledModel: match,
    ));

    // 4) immediately restore to Loaded so that next tap will again go Loaded→Navigate
    emit(SavedCoursesLoaded(_cachedCourses, _cachedCount));
  }
}
