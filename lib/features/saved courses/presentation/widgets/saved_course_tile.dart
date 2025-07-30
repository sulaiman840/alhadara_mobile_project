import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import '../../data/model/saved_course_model.dart';

class SavedCourseTile extends StatelessWidget {
  final SavedCourse course;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const SavedCourseTile({
    super.key,
    required this.course,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.primary;
    return Material(
      color:Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  '${ConstString.baseURl}${course.photo}',
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80.w,
                    height: 80.w,
                    color: theme.dividerColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: theme.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      course.description,
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.solidBookmark,
                  size: 20.r,
                ),
                color: iconColor,
                onPressed: onBookmarkTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
