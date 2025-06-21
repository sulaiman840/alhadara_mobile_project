
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';


class FinishedCoursesPage extends StatefulWidget {
  const FinishedCoursesPage({Key? key}) : super(key: key);

  @override
  _FinishedCoursesPageState createState() => _FinishedCoursesPageState();
}

class _FinishedCoursesPageState extends State<FinishedCoursesPage> {
  final List<Map<String, String>> _courses = [
    {
      'image': 'assets/images/English.jpg',
      'title': 'كورس اللغة الانجليزية للمبتدئين',
      'subtitle': 'تعلم اساسيات اللغة',
      'duration': '2/5/2025',
      'teacher': 'ا. احمد علي',
    },
    {
      'image': 'assets/images/English2.jpg',
      'title': 'كورس متقدم اللغة الانجليزية ',
      'subtitle': 'مستوى متقدم',
      'duration': '2/5/2025',
      'teacher': 'ا. احمد علي',
    },

  ];



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'الكورسات المنتهية',
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: _courses.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColor.gray3, thickness: 0.2.h),
                    itemBuilder: (_, i) {
                      final c = _courses[i];
                      return InkWell(
                        onTap: () {GoRouter.of(context).go(AppRoutesNames.courseDetails);

                          // TODO: navigate to course details
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ── Thumbnail on the right
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.asset(
                                  c['image']!,
                                  width: 80.w,
                                  height: 80.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12.w),

                              // ── Course info in the middle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c['title']!,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.textDarkBlue,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      c['subtitle']!,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColor.textDarkBlue
                                            .withValues(alpha: 0.7),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14.r,
                                          color: AppColor.gray3,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          c['duration']!,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColor.gray3,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Icon(
                                          Icons.person,
                                          size: 14.r,
                                          color: AppColor.gray3,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          c['teacher']!,
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



                            ],
                          ),
                        ),
                      );
                    },
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
