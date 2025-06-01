import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double horizontalPadding;
  final double height;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.horizontalPadding = 24.0,
    this.height = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      child: SizedBox(
        width: double.infinity,
        height: height.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
