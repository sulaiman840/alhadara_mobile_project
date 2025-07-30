import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';

import '../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../../my_course_details/cubit/my_courses_state.dart';
import '../../../saved courses/cubit/saved_courses_cubit.dart';
import '../../../saved courses/cubit/saved_courses_state.dart';


class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  _MyCoursesPageState createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyCoursesCubit>().fetchMyCourses();
    context.read<SavedCoursesCubit>().fetchSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'قائمة كورساتي',
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<SavedCoursesCubit, SavedCoursesState>(
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
                    if (myState is MyCoursesLoading ||
                        myState is MyCoursesInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (myState is MyCoursesFailure) {
                      return Center(
                        child: Text(
                          myState.errorMessage,
                          style:
                          TextStyle(color: Colors.red, fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    final list = (myState as MyCoursesSuccess).courses;
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'لم تقم بالتسجيل في أي كورس بعد',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: AppColor.gray3, thickness: 0.2.h),
                      itemBuilder: (_, i) {
                        final enrolled = list[i];
                        final isSaved =
                        savedIds.contains(enrolled.course.id);
                        final imageUrl =
                            '${ConstString.baseURl}${enrolled.course.photo}';

                        return InkWell(
                          onTap: () => context.pushNamed(
                            'myCourseDetails',
                            pathParameters: {
                              'enrolledId': enrolled.id.toString(),
                            },
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    imageUrl,
                                    width: 80.w,
                                    height: 80.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) => Container(
                                      width: 80.w,
                                      height: 80.w,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 24.r,
                                        color: AppColor.gray3,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        enrolled.course.name,
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
                                        'شعبة: ${enrolled.name}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColor.textDarkBlue
                                              .withValues(alpha: 0.7),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14.r,
                                            color: AppColor.gray3,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '${enrolled.startDate.day}/${enrolled.startDate.month}/${enrolled.startDate.year}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColor.gray3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                GestureDetector(
                                  onTap: () {
                                    ctxSave
                                        .read<SavedCoursesCubit>()
                                        .toggleSaved(
                                      enrolled.course.id,
                                      isSaved,
                                    );
                                  },
                                  child: FaIcon(
                                    isSaved
                                        ? FontAwesomeIcons.solidBookmark
                                        : FontAwesomeIcons.bookmark,
                                    size: 16.r,
                                    color: isSaved
                                        ? AppColor.purple
                                        : AppColor.gray3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
