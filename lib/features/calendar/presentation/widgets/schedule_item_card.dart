import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import '../../data/models/schedule_event_model.dart';

class ScheduleItemCard extends StatelessWidget {
  final ScheduleEventModel event;

  const ScheduleItemCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoUrl = '${ConstString.baseURl}${event.course.photo}';

    return Card(
      color: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                photoUrl,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80.w,
                  height: 80.h,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event.startTime.substring(0,5)} – ${event.endTime.substring(0,5)}',
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: Colors.white70),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    event.course.name,
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    event.sectionName,
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
