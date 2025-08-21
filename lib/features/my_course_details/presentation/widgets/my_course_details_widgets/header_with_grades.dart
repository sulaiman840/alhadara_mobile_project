import 'package:alhadara_mobile_project/features/my_course_details/presentation/widgets/my_course_details_widgets/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/app_localizations.dart';
import 'grades_bottom_sheet.dart';
import 'section_progress_view.dart';

class HeaderWithGrades extends StatelessWidget {
  final int sectionId; // NEW
  final String sectionName;
  final String activeSince;
  final List<({int examId, String examName, double? grade})> grades;

  const HeaderWithGrades({
    super.key,
    required this.sectionId,       // NEW
    required this.sectionName,
    required this.activeSince,
    required this.grades,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: name (left) + progress (right)
        Row(
          children: [
            Expanded(
              child: Text(
                sectionName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            SectionProgressView(sectionId: sectionId), // NEW
          ],
        ),
        SizedBox(height: 12.h),

        // Row: active since + grades button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Active since chip
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${loc.tr('active_since_label')} $activeSince',
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.green),
              ),
            ),
            // Grades button
            OutlinedButton.icon(
              onPressed: grades.isEmpty
                  ? null
                  : () => GradesBottomSheet.show(
                context: context,
                grades: grades,
                courseName: sectionName,
              ),
              icon: Icon(Icons.workspace_premium, size: 18.r),
              label: Text(
                UiHelpers.safeTr(loc, 'grades_button', fallback: loc.tr('display_grades')),
                style: theme.textTheme.bodyMedium,
              ),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1,
                ),
                foregroundColor: theme.colorScheme.primary,
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
