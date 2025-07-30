import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/const.dart';
import '../../data/models/trainer_with_course_model.dart';

class CourseItemTile extends StatelessWidget {
  final Course course;
  const CourseItemTile({super.key, required this.course});

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyLarge = theme.textTheme.bodyLarge!;
    final bodySmall = theme.textTheme.bodySmall!;
    final photo = course.photo.isNotEmpty
        ? '${ConstString.baseURl}${course.photo}'
        : 'assets/images/placeholder.png';
    final date = _formatDate(course.createdAt);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                blurRadius: 6.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: photo.startsWith('http')
                    ? Image.network(photo, width: 60.w, height: 60.h, fit: BoxFit.cover)
                    : Image.asset(photo,    width: 60.w, height: 60.h, fit: BoxFit.cover),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: bodyLarge.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      date,
                      style: bodySmall.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
