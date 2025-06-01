import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({
    Key? key,
    this.message = 'جارٍ تحميل...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ModalBarrier(
          color: Colors.black54,
          dismissible: false,
        ),

        // Centered white card with spinner + text
        Center(
          child: Container(
            width: 180.w,
            padding: EdgeInsets.symmetric(
              vertical: 24.h,
              horizontal: 16.w,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 48.w,
                  width: 48.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5.w,
                    color: AppColor.purple,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textDarkBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
