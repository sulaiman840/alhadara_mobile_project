import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

import '../../../../core/localization/app_localizations.dart';


class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

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
             loc.tr('Or'),
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
