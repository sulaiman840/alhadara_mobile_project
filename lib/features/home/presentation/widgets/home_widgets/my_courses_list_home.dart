import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/const.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/navigation/routes_names.dart';
import '../../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../../../my_course_details/cubit/my_courses_state.dart';


class MyCoursesListHome extends StatelessWidget {
  const MyCoursesListHome({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<MyCoursesCubit, MyCoursesState>(
      builder: (context, state) {
        if (state is MyCoursesLoading || state is MyCoursesInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is MyCoursesFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (state is MyCoursesSuccess) {
          final list = state.courses;
          if (list.isEmpty) {
            return Center(
              child: Text(
                loc.tr('you_did_not_book_any_course_yet'),
                style: TextStyle(fontSize: 14.sp,  color: Theme.of(context).colorScheme.onSurface,),
              ),
            );
          }
          return SizedBox(
            height: 160.h,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 45.w),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, i) {
                      final e = list[i];
                      final img = e.course.photo.startsWith('http')
                          ? e.course.photo
                          : '${ConstString.baseURl}${e.course.photo}';
                      return GestureDetector(
                        onTap: () => context.pushNamed(
                          'myCourseDetails',
                          pathParameters: {'enrolledId': e.id.toString()},
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                img,
                                width: 120.w,
                                height: 120.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: 120.w,
                              child: Text(
                                e.course.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,

                      fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20.r),
                    onPressed: () => context.push(AppRoutesNames.myCourses),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
