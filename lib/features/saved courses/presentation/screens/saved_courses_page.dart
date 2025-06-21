// lib/features/saved_courses/presentation/screens/saved_courses_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/shared/widgets/custom_app_bar.dart';

import '../../../home/data/models/course_model.dart';
import '../../../my_course_details/data/models/enrolled_course_model.dart';
import '../../cubit/saved_courses_cubit.dart';
import '../../cubit/saved_courses_state.dart';
import '../../data/model/saved_course_model.dart';


class SavedCoursesPage extends StatelessWidget {
  const SavedCoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'الكورسات المحفوظة',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: BlocListener<SavedCoursesCubit, SavedCoursesState>(
          listenWhen: (prev, curr) =>
          curr is SavedCoursesNavigate && prev is! SavedCoursesNavigate,
          listener: (ctx, state) {
            final nav = state as SavedCoursesNavigate;

            if (nav.isEnrolled) {
              // ONLY pass the enrolledId—no extra model object:
              ctx.pushNamed(
                'myCourseDetails',
                pathParameters: {
                  'enrolledId': nav.enrolledModel!.id.toString(),
                },

              );
            } else {
              // unchanged for the non-enrolled branch:
              ctx.pushNamed(
                'courseDetails',
                extra: {
                  'course': nav.courseModel.toJson(),
                  'deptName': '',
                },
              );
            }
          },
          child:
          BlocBuilder<SavedCoursesCubit, SavedCoursesState>(
            buildWhen: (p, c) => c is! SavedCoursesNavigate,
            builder: (ctx, state) {
              if (state is SavedCoursesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SavedCoursesError) {
                return Center(child: Text(state.message));
              }

              final loaded    = state as SavedCoursesLoaded;
              final courses   = loaded.courses;
              final favorites = courses.map((c) => c.id).toSet();

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                itemCount: courses.length,
                separatorBuilder: (_, __) =>
                    Divider(color: AppColor.gray3, thickness: 0.2.h),
                itemBuilder: (_, i) {
                  final c     = courses[i];
                  final isFav = favorites.contains(c.id);

                  return _SavedCourseTile(
                    course:        c,
                    isFav:         isFav,
                    onTap:         () => ctx.read<SavedCoursesCubit>().selectCourse(c),
                    onBookmarkTap: () => ctx.read<SavedCoursesCubit>().toggleSaved(c.id, isFav),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
class _SavedCourseTile extends StatelessWidget {
  final SavedCourse course;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const _SavedCourseTile({
    required this.course,
    required this.isFav,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                '${ConstString.baseURl}${course.photo}',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textDarkBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.textDarkBlue.withAlpha(180),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onBookmarkTap,
              child: FaIcon(
                isFav
                    ? FontAwesomeIcons.solidBookmark
                    : FontAwesomeIcons.bookmark,
                size: 20.r,
                color: isFav ? AppColor.purple : AppColor.gray3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
