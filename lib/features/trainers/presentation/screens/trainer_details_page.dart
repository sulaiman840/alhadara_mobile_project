
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class TrainerDetailsPage extends StatelessWidget {
  final Trainer trainer = const Trainer(
    name: 'مريم علي',
    specialty: 'لغة إنكليزية',
    bio: 'بكالوريوس في الآداب قسم اللغة الإنجليزية جامعة دمشق',
    imagePath: 'assets/images/girl2.jpg',
    courses: [
      _Course(
        title: 'أساسيات اللغة الإنجليزية',
        duration: '1/1/2023',
        imagePath: 'assets/images/English3.jpg',
      ),
      _Course(
        title: 'كورس متقدم في اللغة الإنجليزية',
        duration: '2/2/2024',
        imagePath: 'assets/images/English2.jpg',
      ),
      _Course(
        title: 'محادثة متقدمة لغة إنجليزية',
        duration: '2/3/2025',
        imagePath: 'assets/images/English.jpg',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'تفاصيل المدرب',
          onBack: () => context.go(AppRoutesNames.trainers),
        ),
        backgroundColor: AppColor.background,
        body: CustomScrollView(
          slivers: [
            // ── Banner ─────────────────────────────
            SliverAppBar(
              pinned: false,
              expandedHeight: 250.h,
              backgroundColor: AppColor.background,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  trainer.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ── Details + Courses ──────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(64.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Trainer Info
                    Text(
                      trainer.name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      trainer.specialty,
                      style: TextStyle(fontSize: 14.sp, color: AppColor.gray3),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      'نبذة عن المدرب',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      trainer.bio,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textDarkBlue,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Courses Header
                    Text(
                      'كورسات (${trainer.courses.length})',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 16.h),


                    ...trainer.courses.map((c) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: InkWell(
                          onTap: () {

                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.background,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.textDarkBlue.withValues(alpha: 0.5),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                // 1) Course thumbnail (start in RTL)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.asset(
                                    c.imagePath,
                                    width: 60.w,
                                    height: 60.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12.w),


                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.title,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.textDarkBlue,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        c.duration,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColor.gray3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 3) Arrow icon
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.r,
                                  color: AppColor.gray3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),


                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Domain models

class Trainer {
  final String name;
  final String specialty;
  final String bio;
  final String imagePath;
  final List<_Course> courses;
  const Trainer({
    required this.name,
    required this.specialty,
    required this.bio,
    required this.imagePath,
    required this.courses,
  });
}

class _Course {
  final String title;
  final String duration;
  final String imagePath;
  const _Course({
    required this.title,
    required this.duration,
    required this.imagePath,
  });
}
