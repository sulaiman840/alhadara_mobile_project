import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import '../../../home/data/models/course_model.dart';

class CourseDetailsPage extends StatefulWidget {
  final CourseModel course;
  final String deptName;

  const CourseDetailsPage({
    Key? key,
    required this.course,
    required this.deptName,
  }) : super(key: key);

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  // Kept in case you later add pinned tabs again
  bool _tabsPinned = false;

  @override
  Widget build(BuildContext context) {
    const bannerHeight = 300.0;
    const forumBtnH = 48.0;

    final bannerPx = bannerHeight.h;
    final forumPx = forumBtnH.h;
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;

    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return DefaultTabController(
      length: 1,
      child: NotificationListener<ScrollNotification>(
        onNotification: (sn) {
          if (sn.depth != 0) return false;
          final offset = sn.metrics.pixels;
          final shouldPin = offset >= pinThreshold;
          if (shouldPin != _tabsPinned) {
            setState(() => _tabsPinned = shouldPin);
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: CustomAppBar(
            title: loc.tr('course_details_default_title'),
          ),
          body: CustomScrollView(
            slivers: [
              // Banner
              SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    '${ConstString.baseURl}${widget.course.photo}',
                    width: double.infinity,
                    height: bannerPx,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 200.h,
                      color: theme.cardColor,
                      child: Icon(
                        Icons.broken_image,
                        size: 40.r,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    loadingBuilder: (ctx, child, loading) {
                      if (loading == null) return child;
                      return Container(
                        height: 200.h,
                        color: theme.cardColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                            value: loading.expectedTotalBytes != null
                                ? loading.cumulativeBytesLoaded /
                                (loading.expectedTotalBytes!)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 12.h)),

              // Pending sections / temporary registration button
              SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: 250.w,
                    height: forumPx,
                    child: OutlinedButton(
                      onPressed: () {
                        context.push(
                          AppRoutesNames.pendingSections,
                          extra: {
                            'course': widget.course,
                            'deptName': widget.deptName,
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.r,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        loc.tr('temporary_registration'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 24.h)),

              // Text content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course name
                      Text(
                        widget.course.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      SizedBox(height: 12.h),

                      // Description
                      Text(
                        widget.course.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
