// lib/features/trainers/presentation/screens/trainer_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/models/trainer_with_course_model.dart';

class TrainerDetailsPage extends StatelessWidget {
  final Trainer trainer;
  final List<Course> courses;

  const TrainerDetailsPage({
    Key? key,
    required this.trainer,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Banner photo
    final photoUrl = trainer.photo != null
        ? '${ConstString.baseURl}${trainer.photo}'
        : 'assets/images/placeholder.png';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(title: 'تفاصيل المدرب'),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              expandedHeight: 250.h,
              backgroundColor: AppColor.background,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: photoUrl.startsWith('http')
                    ? Image.network(photoUrl, fit: BoxFit.contain)
                    : Image.asset(photoUrl, fit: BoxFit.contain),
              ),
            ),
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
                    // Trainer info
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
                      trainer.specialization,
                      style: TextStyle(fontSize: 14.sp, color: AppColor.gray3),
                    ),
                    SizedBox(height: 16.h),

                    // Bio
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
                      trainer.experience,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textDarkBlue,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Courses header
                    Text(
                      'كورسات (${courses.length})',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // List all courses
                    ...courses.map((course) {
                      final courseImageUrl = course.photo.isNotEmpty
                          ? '${ConstString.baseURl}${course.photo}'
                          : 'assets/images/placeholder.png';
                      final duration =
                          '${course.createdAt.day}/${course.createdAt.month}/${course.createdAt.year}';

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: InkWell(
                          onTap: () {
                            // TODO: navigate to course details
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.background,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.textDarkBlue.withOpacity(0.5),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: courseImageUrl.startsWith('http')
                                      ? Image.network(
                                    courseImageUrl,
                                    width: 60.w,
                                    height: 60.h,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    courseImageUrl,
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
                                        course.name,
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
                                        duration,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColor.gray3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

                    SizedBox(height: 120.h),
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
