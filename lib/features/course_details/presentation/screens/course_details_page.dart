import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../home/data/models/course_model.dart';

class CourseDetailsPage extends StatefulWidget {
  final CourseModel course;
  final String deptName;

  const CourseDetailsPage({
    Key? key,
    required this.course,
    required this.deptName,
  }) : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  bool _tabsPinned = false;

  @override
  Widget build(BuildContext context) {
    const bannerHeight = 300.0;
    const forumBtnH = 48.0;

    final bannerPx = bannerHeight.h;
    final forumPx = forumBtnH.h;
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;


    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (sn) {
            if (sn.depth != 0) return false;
            final offset = sn.metrics.pixels;
            final shouldPin = offset >= pinThreshold;
            if (shouldPin != _tabsPinned) {
              setState(() => _tabsPinned = shouldPin);
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColor.background,
            appBar: CustomAppBar(
              title: 'تفاصيل الكورس',
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      '${ConstString.baseURl}${widget.course.photo}',
                      width: double.infinity,
                      height: 300.h,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 200.h,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.broken_image,
                          size: 40.r,
                          color: AppColor.gray3,
                        ),
                      ),
                      loadingBuilder: (ctx, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200.h,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes!)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 250.w,
                      height: forumPx,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(
                            AppRoutesNames.pendingSections,
                            extra: {
                              'course': widget.course,
                              'deptName': widget.deptName,
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColor.purple,
                          side: BorderSide(color: AppColor.purple, width: 2.r),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                        child: Text(
                          'التسجيل المؤقت',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course name
                        Text(
                          widget.course.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        Text(
                          widget.course.description,
                          style: TextStyle(
                              fontSize: 14.sp, color: AppColor.textDarkBlue),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}




