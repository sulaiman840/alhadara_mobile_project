import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.leading,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Widget leading;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Material(
        elevation: selected ? 4 : 1,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 2.r,
              ),
            ),
            child: Row(
              children: [
                leading,
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
