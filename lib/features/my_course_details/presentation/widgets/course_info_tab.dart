import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

class CourseInfoTab extends StatelessWidget {
  final String description;
  final AppLocalizations loc;

  const CourseInfoTab({
    super.key,
    required this.description,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Text(
        description.isNotEmpty
            ? description
            : loc.tr('no_additional_course_info'),
        style: theme.textTheme.bodyMedium!
            .copyWith(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
