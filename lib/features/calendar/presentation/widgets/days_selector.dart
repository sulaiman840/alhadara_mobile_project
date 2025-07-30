import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DaysSelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const DaysSelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onDaySelected(i),
            child: Container(
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? scheme.primary : scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                days[i],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: selected ? scheme.onPrimary : scheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
