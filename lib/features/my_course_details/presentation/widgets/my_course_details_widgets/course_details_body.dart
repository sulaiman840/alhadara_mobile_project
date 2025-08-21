import 'package:alhadara_mobile_project/features/my_course_details/presentation/widgets/my_course_details_widgets/tabs_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/injection.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/const.dart';
import '../../../../ratings/cubit/ratings_cubit.dart';
import '../../../../ratings/presentation/widgets/section_rating_widget.dart';
import '../../../cubit/my_courses_state.dart';
import 'course_banner.dart';
import 'forum_cta.dart';
import 'header_with_grades.dart';

class CourseDetailsBody extends StatelessWidget {
  final MyCoursesState state;
  final int enrolledId;
  final double bannerPx;
  final double forumPx;
  final bool tabsPinned;

  const CourseDetailsBody({super.key,
    required this.state,
    required this.enrolledId,
    required this.bannerPx,
    required this.forumPx,
    required this.tabsPinned,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    if (state is MyCoursesLoading || state is MyCoursesInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is MyCoursesFailure) {
      return Center(child: Text((state as MyCoursesFailure).errorMessage));
    }

    final success = state as MyCoursesSuccess;
    final enrolled = success.courses.firstWhere(
          (e) => e.id == enrolledId,
      orElse: () => throw Exception('Enrolled section not found: $enrolledId'),
    );
    final course = enrolled.course;
    final created = course.createdAt;
    final activeSince = '${created.day}/${created.month}/${created.year}';
    final bannerUrl = course.photo.isNotEmpty ? '${ConstString.baseURl}${course.photo}' : null;

    return CustomScrollView(
      slivers: [
        // Banner
        SliverToBoxAdapter(
          child: CourseBanner(url: bannerUrl, height: bannerPx),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),

        // Forum CTA
        SliverToBoxAdapter(
          child: ForumCta(sectionId: enrolled.id, height: forumPx),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWithGrades(
                  sectionId: enrolled.id,
                  sectionName: enrolled.name,
                  activeSince: activeSince,
                  grades: enrolled.grades,
                ),
                // Ratings
                BlocProvider<RatingsCubit>(
                  create: (_) => getIt<RatingsCubit>()..loadSectionRatings(enrolled.id),
                  child: SectionRatingWidget(sectionId: enrolled.id),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),

        ...TabsSection.buildSlivers(
          pinned: tabsPinned,
          sectionId: enrolled.id,
          description: course.description,
          loc: loc,
        ),
      ],
    );
  }
}
