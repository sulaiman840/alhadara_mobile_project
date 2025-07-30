import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/trainer_with_course_model.dart';

class TrainerInfoSection extends StatelessWidget {
  final Trainer trainer;
  const TrainerInfoSection({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bodyLarge = theme.textTheme.bodyLarge!;
    final bodySmall = theme.textTheme.bodySmall!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trainer.name,
          style: bodyLarge.copyWith(fontWeight: FontWeight.bold, fontSize: 22.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          trainer.specialization,
          style: bodySmall.copyWith(fontSize: 14.sp),
        ),
        SizedBox(height: 16.h),
        Text(
          loc.tr('trainer_bio_title'),
          style: bodyLarge.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          trainer.experience,
          style: bodySmall.copyWith(fontSize: 14.sp, height: 1.4),
        ),
      ],
    );
  }
}
