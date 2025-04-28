import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> _todayNotifications = [
    {
      'type': 'comment',
      'title': 'مريم علي علّقت على منتدى فلاتر',
      'content': 'كورس مفيد ينصح بها.',
      'avatar': 'assets/images/girl.png',
      'time': '09:45',
    },
    {
      'type': 'course',
      'label': 'كورس جديد',
      'subtitle': 'كورس فلاتر للمبتدئين',
      'thumbnail': 'assets/images/Flutter.png',
      'authorAvatar': 'assets/images/man.png',
      'authorName': 'احمد علي',
      'time': '08:58',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'الإشعارات',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section header
              Text(
                'اليوم',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColor.textDarkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),

              Expanded(
                child: ListView.separated(
                  itemCount: _todayNotifications.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColor.gray3,
                    thickness: 0.2.h,
                    height: 16.h,
                  ),
                  itemBuilder: (ctx, idx) {
                    final n = _todayNotifications[idx];
                    if (n['type'] == 'comment') {
                      // ——————— comment style ———————
                      return Row(
                        children: [
                          // avatar on the right
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: AssetImage(n['avatar']),
                          ),
                          SizedBox(width: 12.w),
                          // title + content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  n['title'],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.textDarkBlue,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  n['content'],
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColor.gray3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // time on the left
                          Text(
                            n['time'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.gray3,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // ——————— course style ———————
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColor.background,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            // thumbnail (rightmost)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                n['thumbnail'],
                                width: 80.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // text column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n['label'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.purple,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    n['subtitle'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.textDarkBlue,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12.r,
                                        backgroundImage:
                                        AssetImage(n['authorAvatar']),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        n['authorName'],
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColor.gray3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // time on the left
                            Text(
                              n['time'],
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColor.gray3,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
