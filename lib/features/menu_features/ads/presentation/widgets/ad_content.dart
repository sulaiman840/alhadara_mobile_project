import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ad_date_row.dart';

class AdContent extends StatelessWidget {
  final String title, description;
  final DateTime startDate, endDate;

  const AdContent({super.key,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          AdDateRow(
            formatted: '${_fmt(startDate)} → ${_fmt(endDate)}',
          ),
        ],
      ),
    );
  }
}
