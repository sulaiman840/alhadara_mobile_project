import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';


class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(color: AppColor.gray3, thickness: 1.h),
          Container(
            color: AppColor.background,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'أو',
              style: TextStyle(
                color: AppColor.textDarkBlue,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
