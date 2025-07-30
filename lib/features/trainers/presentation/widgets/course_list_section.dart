import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/trainer_with_course_model.dart';
import 'course_item_tile.dart';

class CourseListSection extends StatelessWidget {
  final List<Course> courses;
  const CourseListSection({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium!
        .copyWith(fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${loc.tr('trainer_courses_title')} (${courses.length})',
          style: titleStyle,
        ),
        SizedBox(height: 16.h),
        ...courses.map((c) => CourseItemTile(course: c)),
      ],
    );
  }
}
