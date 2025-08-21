import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../../data/models/course_model.dart';
import 'course_image_course_list_widget.dart';
import 'saved_bookmark_button.dart';

class CourseListItem extends StatelessWidget {
  final CourseModel course;
  final bool isSaved;
  final String departmentName;
  final VoidCallback onToggleSaved;

  const CourseListItem({
    super.key,
    required this.course,
    required this.isSaved,
    required this.departmentName,
    required this.onToggleSaved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        context.push(
          AppRoutesNames.courseDetails,
          extra: {
            'course': course.toJson(),
            'deptName': departmentName,
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CourseImageCourseListWidget(
              imageUrl: '${ConstString.baseURl}${course.photo}',
              size: 80.w,
              borderRadius: 12.r,
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
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
                    course.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),
            SavedBookmarkButton(
              isSaved: isSaved,
              onTap: onToggleSaved,
            ),
          ],
        ),
      ),
    );
  }
}
