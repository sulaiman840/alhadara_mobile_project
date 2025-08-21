import 'package:alhadara_mobile_project/features/my_course_details/presentation/widgets/my_course_details_widgets/ui_helpers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseBanner extends StatelessWidget {
  final String? url;
  final double height;

  const CourseBanner({super.key, required this.url, required this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: url != null
          ? Image.network(
        url!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => UiHelpers.placeholderBanner(height, theme),
      )
          : UiHelpers.placeholderBanner(height, theme),
    );
  }
}
