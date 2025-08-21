import 'package:alhadara_mobile_project/features/home/presentation/widgets/my_courses_list_widgets/saved_bookmark_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

import 'my_course_square_image.dart';



class MyCourseListItem extends StatelessWidget {
  final int enrolledId;
  final int courseId;
  final String courseName;
  final String sectionName;
  final String imageUrl;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  const MyCourseListItem({
    super.key,
    required this.enrolledId,
    required this.courseId,
    required this.courseName,
    required this.sectionName,

    required this.imageUrl,
    required this.isSaved,
    required this.onToggleSaved,
  });

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return InkWell(
      onTap: () => context.pushNamed(
        'my_course_details_widgets',
        pathParameters: {'enrolledId': enrolledId.toString()},
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyCourseSquareImage(
              imageUrl: imageUrl,
              size: 80.w,
              borderRadius: 12.r,
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course name
                  Text(
                    courseName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),


                  Text(
                    '${loc.tr('group_label')}: $sectionName',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                ],
              ),
            ),

            SizedBox(width: 12.w),


            SavedBookmarkIcon(
              isSaved: isSaved,
              onTap: onToggleSaved,
            ),
          ],
        ),
      ),
    );
  }
}
