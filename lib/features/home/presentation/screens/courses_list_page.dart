
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';


class CoursesListPage extends StatefulWidget {
  const CoursesListPage({Key? key}) : super(key: key);

  @override
  _CoursesListPageState createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  final List<Map<String, String>> _courses = [
    {
      'image': 'assets/images/Flutter.png',
      'title': 'Flutter للمبتدئين',
      'subtitle': 'تعلم فلاتر من الصفر',
      'duration': '2/5/2025',
      'teacher': 'ا. احمد علي',
    },
    {
      'image': 'assets/images/laravel.png',
      'title': 'Laravel متقدمة',
      'subtitle': 'دورة احتراف Laravel',
      'duration': '2/5/2025',
      'teacher': 'ا. احمد علي',
    },
    {
      'image': 'assets/images/programming.jpg',
      'title': 'مبادئ البرمجة',
      'subtitle': 'أساسيات',
      'duration': '2/5/2025',
      'teacher': 'ا. احمد علي',
    },
  ];

  late List<bool> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List<bool>.filled(_courses.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = 40.r;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'قائمة كورسات البرمجة',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: _courses.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColor.gray3, thickness: 0.2.h),
                    itemBuilder: (_, i) {
                      final c = _courses[i];
                      return InkWell(
                        onTap: () {
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
                                            .withOpacity(0.7),
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
                              SizedBox(width: 12.w),

                              // ── Heart on the left
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _favorites[i] = !_favorites[i];
                                  });
                                },
                                child: FaIcon(
                                  _favorites[i]
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  size: 20.r,
                                  color: _favorites[i]
                                      ? AppColor.purple
                                      : AppColor.gray3,
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
