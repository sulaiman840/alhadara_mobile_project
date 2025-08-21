import 'package:alhadara_mobile_project/features/my_course_details/presentation/widgets/my_course_details_widgets/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/localization/app_localizations.dart';

class GradesBottomSheet {
  static void show({
    required BuildContext context,
    required List<({int examId, String examName, double? grade})> grades,
    required String courseName,
  }) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);


    final isArabic = Localizations.localeOf(context).languageCode.toLowerCase().startsWith('ar');
    final textDir = isArabic ? TextDirection.rtl : TextDirection.ltr;


    final valid = grades.where((g) => g.grade != null).map((g) => g.grade!).toList();
    final double? avg = valid.isEmpty ? null : (valid.reduce((a, b) => a + b) / valid.length);


    final titleText = UiHelpers.safeTr(
      loc,
      'grades_title',
      fallback: UiHelpers.safeTr(loc, 'display_grades', fallback: 'علامات المقرر'),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => Directionality(
        textDirection: textDir,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$titleText - $courseName',
                      style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              if (avg != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${UiHelpers.safeTr(loc, "grades_average", fallback: "المعدل")}: ${avg.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              if (avg != null) SizedBox(height: 10.h),

              if (grades.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Text(
                    UiHelpers.safeTr(loc, 'no_grades_yet', fallback: 'لا توجد علامات حتى الآن'),
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: grades.length,
                  separatorBuilder: (_, __) => Divider(height: 12.h),
                  itemBuilder: (_, i) {
                    final g = grades[i];
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            g.examName.isEmpty
                                ? UiHelpers.safeTr(loc, 'exam', fallback: 'امتحان')
                                : g.examName,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          g.grade == null ? '—' : g.grade!.toStringAsFixed(2),
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
