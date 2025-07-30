import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../cubit/points_cubit.dart';
import '../../cubit/departments_cubit.dart';
import '../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../cubit/recommendations_cubit.dart';
import '../widgets/home_widgets/header_section.dart';
import '../widgets/home_widgets/search_bar.dart';
import '../widgets/home_widgets/points_bar.dart';
import '../widgets/home_widgets/section_title.dart';
import '../widgets/home_widgets/department_chips.dart';
import '../widgets/home_widgets/my_courses_list_home.dart';
import '../widgets/home_widgets/recommended_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PointsCubit>().loadPoints();
      context.read<DepartmentsCubit>().fetchDepartments();
      context.read<MyCoursesCubit>().fetchMyCourses();
      context.read<RecommendationsCubit>().fetchRecommendations();
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<PointsCubit>().loadPoints(),
      context.read<DepartmentsCubit>().fetchDepartments(),
      context.read<MyCoursesCubit>().fetchMyCourses(),
      context.read<RecommendationsCubit>().fetchRecommendations(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: HomeHeader(),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    SearchBarHome(),
                    SizedBox(height: 16.h),
                    PointsBar(),
                    SizedBox(height: 16.h),

                    SectionTitle(title: loc.tr('departments_title')),
                    SizedBox(height: 12.h),
                    DepartmentChips(),

                    SizedBox(height: 24.h),
                    SectionTitle(title: loc.tr('my_courses_title')),
                    SizedBox(height: 12.h),
                    MyCoursesListHome(),

                    SizedBox(height: 24.h),
                    SectionTitle(title: loc.tr('recommended_title')),
                    SizedBox(height: 12.h),
                    RecommendedGrid(),

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
}
