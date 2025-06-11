// lib/features/home/presentation/screens/courses_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/courses_cubit.dart';
import '../../cubit/courses_state.dart';
import '../../data/models/course_model.dart';

class CoursesListPage extends StatefulWidget {
  final int departmentId;
  final String departmentName;

  const CoursesListPage({
    Key? key,
    required this.departmentId,
    required this.departmentName,
  }) : super(key: key);

  @override
  _CoursesListPageState createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title:'قائمة كورسات ${widget.departmentName}',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<CoursesCubit, CoursesState>(
              builder: (context, state) {
                if (state is CoursesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CoursesFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (state is CoursesSuccess) {
                  final List<CourseModel> courses = state.courses;
                  if (courses.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد كورسات في هذا القسم',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.textDarkBlue,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: courses.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColor.gray3, thickness: 0.2.h),
                    itemBuilder: (_, i) {
                      final c = courses[i];

                      return InkWell(
                        onTap: () {
                          GoRouter.of(context).go(
                            AppRoutesNames.courseDetails,
                            extra: {
                              'course': c,
                              'deptName': widget.departmentName,
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ── Thumbnail on the right
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(
                                  '${ConstString.baseURl}${c.photo}',
                                  width: 80.w,
                                  height: 80.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, error, stack) => Container(
                                    width: 80.w,
                                    height: 80.w,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 40.r,
                                      color: AppColor.gray3,
                                    ),
                                  ),
                                  loadingBuilder: (ctx, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      width: 80.w,
                                      height: 80.w,
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded /
                                              (progress.expectedTotalBytes!)
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // ── Course info in the middle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.name,
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
                                      c.description,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColor.textDarkBlue.withOpacity(0.7),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // ── Bookmark/favorite icon if you want:
                              GestureDetector(
                                onTap: () {
                                  // implement “mark as favorite” if needed
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.bookmark,
                                  size: 20.r,
                                  color: AppColor.gray3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                // default:
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
