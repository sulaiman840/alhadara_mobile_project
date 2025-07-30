import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

class DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const DotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == currentIndex;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: selected ? 15.w : 9.w,
          height: selected ? 15.w : 9.w,
          decoration: BoxDecoration(
            color: selected ? AppColor.purple : AppColor.purple2,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
