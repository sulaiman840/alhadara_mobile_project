// lib/features/auth/ui/my_course_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class MyCourseDetailsPage extends StatelessWidget {
  const MyCourseDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColor.background,
          appBar: CustomAppBar(
            title: 'تفاصيل الكورس',
            onBack: () => context.go(AppRoutesNames.myCourses),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Banner + forum button overlay
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // banner
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          'assets/images/Flutter.png',
                          width: double.infinity,
                          height: 300.h,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // smaller outlined “المنتدى” button
                      Positioned(
                        bottom: -40.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            width: 250.w,
                            height: 60.h,
                            child: OutlinedButton(
                              onPressed: () {
                                /* TODO */
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColor.purple,
                                side: BorderSide(
                                    color: AppColor.background, width: 6.r),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),
                              child: Text(
                                'المنتدى',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // reserve space for the overlapping button
                SizedBox(height: 50.h),

                // ── Course title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'كورس تعلم Flutter: للمبتدئين',
                    style: TextStyle(
                      color: AppColor.textDarkBlue,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // ── “مجاني” tag & rating
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'نشط منذ 1/1/2024',
                          style: TextStyle(
                            color: AppColor.green,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      FaIcon(
                        FontAwesomeIcons.solidStar,
                        size: 14.r,
                        color: AppColor.yellow,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.textDarkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // ── Participants & teacher
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundImage: AssetImage('assets/images/man.png'),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'احمد بلال',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: AppColor.textDarkBlue,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          // TODO: navigate to the trainer’s profile
                          // e.g. context.go(AppRoutesNames.trainerProfile);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'زيارة بروفايل المدرب',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Tabs: الدرس، المشروع، التعليقات
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: TabBar(
                    indicatorColor: AppColor.purple,
                    labelColor: AppColor.purple,
                    unselectedLabelColor: AppColor.gray3,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'الدرس'),
                      Tab(text: 'المشروع'),
                      Tab(text: 'التعليقات'),
                    ],
                  ),
                ),

                // ── Tab views
                SizedBox(
                  height: 300.h,
                  child: TabBarView(
                    children: [
                      // الدرس
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'هذا هو محتوى الدرس. هنا يمكنك إضافة تفاصيل الدرس الأول، الفيديوهات، والعناصر التعريفية.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                      ),
                      // المشروع
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'هنا تجد محتوى المشروع المرتبط بهذا الكورس، بما في ذلك الملفات والمهام المطلوبة.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                      ),
                      // التعليقات
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'لا توجد تعليقات بعد. كن أول من يشارك برأيه!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
