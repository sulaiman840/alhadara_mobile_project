import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alhadara_mobile_project/core/utils/const.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

import '../../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../../../my_course_details/cubit/my_courses_state.dart';
import '../../../../saved courses/cubit/saved_courses_cubit.dart';
import '../../../../saved courses/cubit/saved_courses_state.dart';
import 'my_course_list_item.dart';


class MyCoursesBody extends StatelessWidget {
  const MyCoursesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<SavedCoursesCubit, SavedCoursesState>(
      builder: (ctxSave, saveState) {
        if (saveState is SavedCoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (saveState is SavedCoursesError) {
          return Center(child: Text(saveState.message));
        }

        final savedIds = (saveState as SavedCoursesLoaded)
            .courses
            .map((c) => c.id)
            .toSet();

        return BlocBuilder<MyCoursesCubit, MyCoursesState>(
          builder: (ctxMy, myState) {
            if (myState is MyCoursesLoading || myState is MyCoursesInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (myState is MyCoursesFailure) {
              return Center(
                child: Text(
                  myState.errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final list = (myState as MyCoursesSuccess).courses;
            if (list.isEmpty) {
              return Center(
                child: Text(
                  loc.tr('my_courses_empty'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Theme.of(context).dividerColor, thickness: 0.2.h),
              itemBuilder: (_, i) {
                final enrolled = list[i];
                final isSaved = savedIds.contains(enrolled.course.id);
                final imageUrl = '${ConstString.baseURl}${enrolled.course.photo}';

                return MyCourseListItem(
                  enrolledId: enrolled.id,
                  courseId: enrolled.course.id,
                  courseName: enrolled.course.name,
                  sectionName: enrolled.name,

                  imageUrl: imageUrl,
                  isSaved: isSaved,
                  onToggleSaved: () {
                    ctxSave.read<SavedCoursesCubit>().toggleSaved(
                      enrolled.course.id,
                      isSaved,
                    );
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
