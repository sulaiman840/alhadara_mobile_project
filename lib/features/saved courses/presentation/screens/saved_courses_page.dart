import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/saved_courses_cubit.dart';
import '../../cubit/saved_courses_state.dart';
import '../widgets/saved_course_tile.dart';

class SavedCoursesPage extends StatelessWidget {
  const SavedCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: loc.tr('saved_courses_title'),
        onBack: () => context.go(AppRoutesNames.home),
      ),
      body: BlocListener<SavedCoursesCubit, SavedCoursesState>(
        listenWhen: (prev, curr) => curr is SavedCoursesNavigate,
        listener: (ctx, state) {
          if (state is SavedCoursesNavigate) {
            if (state.isEnrolled) {
              ctx.pushNamed(
                'myCourseDetails',
                pathParameters: {
                  'enrolledId': state.enrolledModel!.id.toString()
                },
              );
            } else {
              ctx.pushNamed(
                'courseDetails',
                extra: {
                  'course': state.courseModel.toJson(),
                  'deptName': '',
                },
              );
            }
          }
        },
        child: BlocBuilder<SavedCoursesCubit, SavedCoursesState>(
          buildWhen: (p, c) => c is! SavedCoursesNavigate,
          builder: (ctx, state) {
            if (state is SavedCoursesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SavedCoursesError) {
              return Center(
                child: Text(loc.tr(state.message)),
              );
            }

            final loaded = state as SavedCoursesLoaded;

            if (loaded.courses.isEmpty) {
              return Center(
                child: Text(loc.tr('saved_courses_no_items')),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              itemCount: loaded.courses.length,
              separatorBuilder: (_, __) => Divider(
                color: Theme.of(context).dividerColor,
                thickness: 0.2.h,
              ),
              itemBuilder: (_, i) {
                final course = loaded.courses[i];
                return SavedCourseTile(
                  course: course,
                  onTap: () =>
                      ctx.read<SavedCoursesCubit>().selectCourse(course),
                  onBookmarkTap: () {
                    final isSaved =
                        loaded.courses.map((c) => c.id).contains(course.id);
                    ctx
                        .read<SavedCoursesCubit>()
                        .toggleSaved(course.id, isSaved);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
