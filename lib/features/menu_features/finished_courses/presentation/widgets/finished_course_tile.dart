import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

import '../../data/models/finished_course_model.dart';

class FinishedCourseTile extends StatelessWidget {
  final FinishedCourseModel model;
  const FinishedCourseTile({super.key, required this.model});

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      return '$d/$m/${dt.year}';
    } catch (_) {
      return iso.split('T').first;
    }
  }

  String _hhmm(String hms) {
    if (hms.isEmpty) return '';
    final parts = hms.split(':');
    if (parts.length < 2) return hms;
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  String _localizedDay(BuildContext ctx, String daySlug) {
    final loc = AppLocalizations.of(ctx);
    switch (daySlug.toLowerCase()) {
      case 'saturday':
        return loc.tr('day_saturday');
      case 'sunday':
        return loc.tr('day_sunday');
      case 'monday':
        return loc.tr('day_monday');
      case 'tuesday':
        return loc.tr('day_tuesday');
      case 'wednesday':
        return loc.tr('day_wednesday');
      case 'thursday':
        return loc.tr('day_thursday');
      case 'friday':
        return loc.tr('day_friday');
      default:
        return daySlug;
    }
  }

  String _scheduleLine(BuildContext ctx) {
    if (model.weekDays.isEmpty) return '';
    return model.weekDays.map((w) {
      final day = _localizedDay(ctx, w.name);
      final s = _hhmm(w.startTime);
      final e = _hhmm(w.endTime);
      if (s.isEmpty || e.isEmpty) return day;
      return '$day $s–$e';
    }).join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Card(
      color: theme.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      shadowColor: theme.colorScheme.onSurface.withOpacity(0.08),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading icon/avatar
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.school, color: theme.colorScheme.primary, size: 28.r),
            ),
            SizedBox(width: 12.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.course.name,
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 16.r, color: theme.colorScheme.primary),
                                SizedBox(width: 4.w),
                                Text(
                                  loc.tr('finished'),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Section name
                  Text(
                    model.sectionName,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),


                  Wrap(
                    spacing: 12.w,
                    runSpacing: 8.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event, size: 18),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              '${loc.tr('date_range')}: ${_fmtDate(model.startDate)} - ${_fmtDate(model.endDate)}',
                              style: theme.textTheme.bodyMedium,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule, size: 18),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              '${loc.tr('total_sessions')}: ${model.totalSessions}',
                              style: theme.textTheme.bodyMedium,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (model.weekDays.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      '${loc.tr('schedule')}: ${_scheduleLine(context)}',
                      style: theme.textTheme.bodySmall,
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
