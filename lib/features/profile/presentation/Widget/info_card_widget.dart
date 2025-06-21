import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class InfoCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoCardWidget({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(color: AppColor.purple2,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, color: AppColor.purple, size: 24.r),
            SizedBox(width: 12.w),
            Text(
              '$label:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.textDarkBlue,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColor.textDarkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}