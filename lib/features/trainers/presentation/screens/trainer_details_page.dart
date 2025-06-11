
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/models/trainer_with_course_model.dart';

class TrainerDetailsPage extends StatelessWidget {
  final TrainerWithCourse trainerWithCourse;
  const TrainerDetailsPage({
    Key? key,
    required this.trainerWithCourse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = trainerWithCourse.trainer;
    final c = trainerWithCourse.course;
    // build full URLs or fall back to placeholder asset
    final photoUrl = t.photo != null
        ? '${ConstString.baseURl}${t.photo}'
        : 'assets/images/placeholder.png';
    final courseImageUrl = c.photo.isNotEmpty
        ? '${ConstString.baseURl}${c.photo}'
        : 'assets/images/placeholder.png';
    // format the created date as “duration”
    final duration = '${c.createdAt.day}/${c.createdAt.month}/${c.createdAt.year}';

    // our “mock” list of courses (API only has one per trainer)
    final courses = [c];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'تفاصيل المدرب',
          onBack: () => context.go(AppRoutesNames.trainers),
        ),
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
                background: photoUrl.startsWith('http')
                    ? Image.network(photoUrl, fit: BoxFit.contain)
                    : Image.asset(photoUrl, fit: BoxFit.contain),
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
                      t.name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      t.specialization,
                      style: TextStyle(fontSize: 14.sp, color: AppColor.gray3),
                    ),
                    SizedBox(height: 16.h),

                    // Bio / experience
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
                      t.experience,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textDarkBlue,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Courses Header
                    Text(
                      'كورسات (${courses.length})',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Course items
                    ...courses.map((course) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: InkWell(
                          onTap: () {
                            // TODO: navigate to course details if desired
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
                                // Course thumbnail
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

                                // Title + duration
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

                                // Arrow icon
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
