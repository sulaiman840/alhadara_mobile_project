import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MyBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.calendarCheck,
      FontAwesomeIcons.bookmark,
      FontAwesomeIcons.user,
      FontAwesomeIcons.gear,
    ];

    final scheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: scheme.surface,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (i) {
            final selected = i == currentIndex;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  width: selected ? 56.w : 48.w,
                  height: selected ? 56.w : 48.w,
                  decoration: BoxDecoration(
                    color: selected
                        ? scheme.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icons[i],
                      size: selected ? 28.r : 24.r,
                      color: selected
                          ? scheme.primary
                          : scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
