import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:alhadara_mobile_project/core/injection.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../../my_course_details/cubit/my_courses_state.dart';
import '../../../ratings/cubit/ratings_cubit.dart';
import '../../../ratings/presentation/widgets/section_rating_widget.dart';
import '../../cubit/section_files_cubit.dart';
import '../../cubit/quiz_cubit.dart';
import '../widgets/course_info_tab.dart';
import '../widgets/homework_tab.dart';
import '../widgets/tests_tab.dart';
import '../widgets/tab_bar_delegate.dart';

class MyCourseDetailsPage extends StatefulWidget {
  final int enrolledId;
  const MyCourseDetailsPage({super.key, required this.enrolledId});

  @override
  State<MyCourseDetailsPage> createState() => _MyCourseDetailsPageState();
}

class _MyCourseDetailsPageState extends State<MyCourseDetailsPage> {
  bool _tabsPinned = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MyCoursesCubit>();
    if (cubit.state is! MyCoursesSuccess) {
      cubit.fetchMyCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bannerPx = 300.h;
    final forumPx = 48.h;
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: NotificationListener<ScrollNotification>(
          onNotification: (sn) {
            if (sn.depth != 0) return false;
            final shouldPin = sn.metrics.pixels >= pinThreshold;
            if (shouldPin != _tabsPinned) setState(() => _tabsPinned = shouldPin);
            return false;
          },
          child: BlocBuilder<MyCoursesCubit, MyCoursesState>(
            builder: (ctx, state) {
              return Scaffold(
                backgroundColor: theme.colorScheme.surface,
                appBar: CustomAppBar(
                  title: _deriveTitle(state, loc),
                ),
                body: _buildBody(state, bannerPx, forumPx, loc, theme),
              );
            },
          ),
        ),
      ),
    );
  }

  String _deriveTitle(MyCoursesState state, AppLocalizations loc) {
    if (state is MyCoursesSuccess) {
      final enrolled = state.courses
          .firstWhere((e) => e.id == widget.enrolledId, orElse: () => throw Exception());
      return enrolled.course.name.isNotEmpty
          ? enrolled.course.name
          : loc.tr('course_details_default_title');
    }
    return loc.tr('course_details_default_title');
  }

  Widget _buildBody(MyCoursesState state, double bannerPx, double forumPx,
      AppLocalizations loc, ThemeData theme) {
    if (state is MyCoursesLoading || state is MyCoursesInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is MyCoursesFailure) {
      return Center(child: Text(state.errorMessage));
    }
    final success = state as MyCoursesSuccess;
    final enrolled = success.courses
        .firstWhere((e) => e.id == widget.enrolledId, orElse: () => throw Exception());
    final course = enrolled.course;
    final created = course.createdAt;
    final activeSince = '${created.day}/${created.month}/${created.year}';

    final bannerUrl = course.photo.isNotEmpty
        ? '${ConstString.baseURl}${course.photo}'
        : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: bannerUrl != null
                ? Image.network(
              bannerUrl,
              width: double.infinity,
              height: bannerPx,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _placeholderBanner(bannerPx, theme),
            )
                : _placeholderBanner(bannerPx, theme),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        SliverToBoxAdapter(
          child: Center(
            child: SizedBox(
              width: 250.w,
              height: forumPx,
              child: OutlinedButton(
                onPressed: () {
                  context.pushNamed(
                    'forum',
                    pathParameters: {'sectionId': enrolled.id.toString()},
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary, width: 2.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  loc.tr('forum_button'),
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18.sp),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrolled.name,
                  style: theme.textTheme.titleLarge!
                      .copyWith(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${loc.tr('active_since_label')} $activeSince',
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: Colors.green),
                  ),
                ),
                BlocProvider<RatingsCubit>(
                  create: (_) =>
                  getIt<RatingsCubit>()..loadSectionRatings(enrolled.id),
                  child: SectionRatingWidget(sectionId: enrolled.id),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),

        SliverPersistentHeader(
          pinned: true,
          delegate: TabBarDelegate(
            tabs: [
              Tab(text: loc.tr('tab_course_info')),
              Tab(text: loc.tr('tab_homework')),
              Tab(text: loc.tr('tab_tests')),
            ],
            pinned: _tabsPinned,
          ),
        ),

        SliverOpacity(
          opacity: _tabsPinned ? 1.0 : 0.5,
          sliver: SliverFillRemaining(
            child: TabBarView(
              children: [
                CourseInfoTab(description: course.description, loc: loc),
                BlocProvider<SectionFilesCubit>(
                  create: (_) =>
                  getIt<SectionFilesCubit>()..fetchFiles(enrolled.id),
                  child: HomeworkTab(sectionId: enrolled.id, loc: loc),
                ),
                BlocProvider<QuizCubit>(
                  create: (_) =>
                  getIt<QuizCubit>()..fetchQuizzes(enrolled.id),
                  child: TestsTab(sectionId: enrolled.id),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholderBanner(double height, ThemeData theme) => Container(
    width: double.infinity,
    height: height,
    color: theme.colorScheme.surface,
    child: Icon(Icons.broken_image,
        size: 40.r, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
  );
}
