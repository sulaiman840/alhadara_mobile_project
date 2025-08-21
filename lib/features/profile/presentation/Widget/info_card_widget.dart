import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      elevation: 2,
      shadowColor: theme.colorScheme.onSurface.withOpacity(0.06),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 22.r, color: theme.colorScheme.primary),
            SizedBox(width: 12.w),

            // Label
            Text(
              label,
              style: theme.textTheme.titleMedium,
            ),

            const Spacer(),

            // Value
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
