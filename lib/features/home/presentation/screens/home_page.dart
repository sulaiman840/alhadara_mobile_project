import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../../my_course_details/cubit/my_courses_state.dart';
import '../../cubit/points_cubit.dart';
import '../../cubit/points_state.dart';
import '../../cubit/departments_cubit.dart';
import '../../cubit/departments_state.dart';
import '../../cubit/recommendations_cubit.dart';
import '../../cubit/recommendations_state.dart';
import '../../data/models/department_model.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pointsCubit = context.read<PointsCubit>();
      if (pointsCubit.state is PointsInitial) {
        pointsCubit.loadPoints();
      }
      final depsCubit = context.read<DepartmentsCubit>();
      if (depsCubit.state is DepartmentsInitial) {
        depsCubit.fetchDepartments();
      }
      final myCourses = context.read<MyCoursesCubit>();
      if (myCourses.state is MyCoursesInitial) {
        myCourses.fetchMyCourses();
      }
      final recommendedCourses = context.read<RecommendationsCubit>();
      if (recommendedCourses.state is RecommendationsInitial) {
        recommendedCourses.fetchRecommendations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: _buildHeader(),
            ),
          ),
        ),
        backgroundColor: AppColor.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: RefreshIndicator(
              onRefresh: () async {
                // fire all three in parallel
                await Future.wait([
                  context.read<PointsCubit>().loadPoints(),
                  context.read<DepartmentsCubit>().fetchDepartments(),
                  context.read<MyCoursesCubit>().fetchMyCourses(),
                  context.read<RecommendationsCubit>().fetchRecommendations(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    _buildSearchBar(),
                    SizedBox(height: 16.h),
                    _buildPointsCapsule(),
                    SizedBox(height: 16.h),
                    _buildSectionTitle('قائمة الأقسام'),
                    SizedBox(height: 12.h),
                    _buildDepartmentChips(),
                    SizedBox(height: 24.h),
                    _buildSectionTitle('قائمة كورساتي'),
                    SizedBox(height: 12.h),
                    _buildMyCoursesCarousel(),
                    SizedBox(height: 24.h),
                    _buildSectionTitle('كورسات مقترحة'),
                    SizedBox(height: 12.h),
                    _buildRecommendedGrid(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final avatarSize = 40.r;
    return Row(
      children: [
        Text(
          'مرحبا بك ..!!',
          style: TextStyle(
            color: AppColor.textDarkBlue,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        _buildCircleIconButton(
          icon: FontAwesomeIcons.solidBell,
          onTap: () {

            context.push(AppRoutesNames.notifications);
          },
        ),
        SizedBox(width: 12.w),
        _buildCircleAvatar(
          imagePath: 'assets/images/man.png',
          onTap: () {
            context.push(AppRoutesNames.profile);
          },
        ),
      ],
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final avatarSize = 40.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.purple, width: 1.5.r),
        ),
        child: Center(
          child: FaIcon(icon, size: 18.r, color: AppColor.textDarkBlue),
        ),
      ),
    );
  }

  Widget _buildCircleAvatar({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    final avatarSize = 40.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.purple, width: 2.r),
        ),
        child: ClipOval(
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => context.push(AppRoutesNames.search),
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColor.gray3),
            SizedBox(width: 8.w),
            Text(
              'ابحث عن كورسات',
              style: TextStyle(color: AppColor.gray3, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCapsule() {
    return BlocBuilder<PointsCubit, PointsState>(
      builder: (context, state) {
        Widget rightSide;
        if (state is PointsLoading) {
          rightSide = const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        } else if (state is PointsFailure) {
          print(state.errorMessage);
          rightSide = Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          );
        } else if (state is PointsSuccess) {
          rightSide = Text(
            '${state.points} نقطة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          );
        } else {
          rightSide = const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColor.purple,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10.w),
                    FaIcon(FontAwesomeIcons.graduationCap,
                        color: Colors.white, size: 20.r),
                    SizedBox(width: 8.w),
                    Text(
                      'نقاطك الحالية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    rightSide,
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ─── NEW: Build a horizontal list of department chips ─────────────────
  Widget _buildDepartmentChips() {
    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
      builder: (context, state) {
        if (state is DepartmentsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DepartmentsFailure) {
          print(state.errorMessage);

          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColor.textDarkBlue,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (state is DepartmentsSuccess) {
          final List<DepartmentModel> list = state.departments;
          if (list.isEmpty) {
            return Center(
              child: Text(
                'لا توجد أقسام حتى الآن',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColor.textDarkBlue,
                ),
              ),
            );
          }
          return SizedBox(
            height: 80.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, i) {
                final dep = list[i];
                // Full URL for department photo:
                final imageUrl = '${ConstString.baseURl}${dep.photo}';
                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutesNames.coursesList,
                      extra: {'id': dep.id, 'name': dep.name},
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Image.network(
                          imageUrl,
                          width: 55.r,
                          height: 48.r,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stack) => Container(
                            width: 48.r,
                            height: 48.r,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.broken_image,
                              size: 24.r,
                              color: AppColor.gray3,
                            ),
                          ),
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 48.r,
                              height: 48.r,
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
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          dep.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.textDarkBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        // default:
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.textDarkBlue,
        ),
      ),
    );
  }

  Widget _buildMyCoursesCarousel() =>
      BlocBuilder<MyCoursesCubit, MyCoursesState>(builder: (c, s) {
        if (s is MyCoursesLoading || s is MyCoursesInitial)
          return Center(child: CircularProgressIndicator());
        if (s is MyCoursesFailure) {
          print(s.errorMessage);
          Text(s.errorMessage,
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
              textAlign: TextAlign.center);
        }

        if (s is MyCoursesSuccess) {
          final list = s.courses;
          if (list.isEmpty)
            return Center(
                child: Text('لم تقم بالتسجيل في أي كورس بعد',
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColor.textDarkBlue)));
          return SizedBox(
              height: 160.h,
              child: Stack(children: [
                Padding(
                    padding: EdgeInsets.only(left: 45.w),
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12.w),
                        itemBuilder: (_, i) {
                          final e = list[i];
                          final img = '${ConstString.baseURl}${e.course.photo}';
                          return GestureDetector(
                              onTap: () => context.pushNamed(
                                    'myCourseDetails',
                                    pathParameters: {
                                      'enrolledId': e.id.toString(),
                                    },
                                  ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        child: Image.network(img,
                                            width: 120.w,
                                            height: 120.h,
                                            fit: BoxFit.cover)),
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                        width: 120.w,
                                        child: Text(e.course.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColor.textDarkBlue,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500))),
                                  ]));
                        })),
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 20.r),
                        onPressed: () =>
                            context.push(AppRoutesNames.myCourses)))
              ]));
        }
        return SizedBox.shrink();
      });

  Widget _buildRecommendedGrid() {
    return BlocBuilder<RecommendationsCubit, RecommendationsState>(
      builder: (context, state) {
        if (state is RecommendationsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RecommendationsFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(color: AppColor.textDarkBlue, fontSize: 14.sp),
            ),
          );
        }
        if (state is RecommendationsSuccess) {
          final courses = state.courses;
          if (courses.isEmpty) {
            return Center(
              child: Text(
                'لا توجد توصيات حالياً',
                style: TextStyle(color: AppColor.textDarkBlue, fontSize: 14.sp),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, i) {
              final c = courses[i];
              final imageUrl = c.photo.isNotEmpty
                  ? '${ConstString.baseURl}${c.photo}'
                  : null;

              return GestureDetector(
                onTap: () {
                  context.pushNamed(
                    'courseDetails',
                    extra: {
                      'course': c.toJson(),
                      'deptName': '',
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: imageUrl != null
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.broken_image,
                                  size: 48.r,
                                  color: AppColor.gray3,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      c.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textDarkBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
