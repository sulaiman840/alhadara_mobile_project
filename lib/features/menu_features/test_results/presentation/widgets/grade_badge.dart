import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

class GradeBadge extends StatelessWidget {
  final double grade;
  const GradeBadge(this.grade, {super.key});

  @override
  Widget build(BuildContext context) {
    final pct = (grade / 100).clamp(0.0, 1.0);
    final text = '${grade.toStringAsFixed(1)}%';
    return CircularPercentIndicator(
      radius: 40.r,
      lineWidth: 8.r,
      percent: pct,
      backgroundColor: AppColor.purple.withValues(alpha: 0.2),
      progressColor: AppColor.purple,
      center: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      animation: true,
      animationDuration: 800,
    );
  }
}
