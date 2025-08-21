import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../../../saved courses/cubit/saved_courses_cubit.dart';
import '../../../../saved courses/cubit/saved_courses_state.dart';
import '../../../cubit/courses_cubit.dart';
import '../../../cubit/courses_state.dart';
import 'course_list_item.dart';

class CoursesListBody extends StatelessWidget {
  final int departmentId;
  final String departmentName;

  const CoursesListBody({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<SavedCoursesCubit, SavedCoursesState>(
      builder: (ctxSaved, savedState) {
        if (savedState is SavedCoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (savedState is SavedCoursesError) {
          return Center(child: Text(savedState.message));
        }

        final savedIds = <int>{
          for (final c in (savedState as SavedCoursesLoaded).courses) c.id
        };

        return BlocBuilder<CoursesCubit, CoursesState>(
          builder: (ctxCourse, courseState) {
            if (courseState is CoursesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (courseState is CoursesFailure) {
              return Center(
                child: Text(
                  courseState.errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final courses = (courseState as CoursesSuccess).courses;

            if (courses.isEmpty) {
              return Center(
                child: Text(
                  loc.tr('no_courses_in_department'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: courses.length,
              separatorBuilder: (_, __) => Divider(
                color: Theme.of(context).dividerColor,
                thickness: 0.2.h,
              ),
              itemBuilder: (_, i) {
                final c = courses[i];
                final isSaved = savedIds.contains(c.id);

                return CourseListItem(
                  course: c,
                  isSaved: isSaved,
                  departmentName: departmentName,
                  onToggleSaved: () {
                    ctxSaved.read<SavedCoursesCubit>().toggleSaved(c.id, isSaved);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
