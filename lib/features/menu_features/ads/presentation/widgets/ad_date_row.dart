import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdDateRow extends StatelessWidget {
  final String formatted;
  const AdDateRow({super.key, required this.formatted});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14.r,
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
        ),
        SizedBox(width: 4.w),
        Text(
          formatted,
          style: theme.textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
