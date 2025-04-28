import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class CourseSearchPage extends StatefulWidget {
  const CourseSearchPage({Key? key}) : super(key: key);

  @override
  _CourseSearchPageState createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  final TextEditingController _searchCtl = TextEditingController();
  final List<Map<String, String>> _courses = List.generate(
    2,
        (i) => {
      'title': 'كورس فلاتر: للمبتدئين',
      'subtitle': '1/1/2024 • بواسطة محمد أحمد',
      'image': 'assets/images/Flutter.png',
    },
  );

  @override
  Widget build(BuildContext context) {
    final filtered = _courses;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'بحث',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.sliders, color: AppColor.textDarkBlue),
                      onPressed: () {
                        // TODO: open filter sheet
                      },
                    ),
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: TextField(
                          controller: _searchCtl,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            icon: Icon(Icons.search, color: AppColor.gray3),
                            hintText: 'ابحث بالكورس',
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // heading with count
              Text(
                '${filtered.length} كورسات في فلاتر',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textDarkBlue,
                ),
              ),

              SizedBox(height: 12.h),

              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (ctx, i) {
                    final c = filtered[i];
                    return InkWell(
                      onTap: () => context.go(AppRoutesNames.courseDetails),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // 1) Thumbnail first in code → will render on the right in RTL
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                c['image']!,
                                width: 80.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // 2) Text in the middle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['title']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.textDarkBlue,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    c['subtitle']!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColor.gray3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // 3) Bookmark icon last in code → will render on the left in RTL
                            FaIcon(
                              FontAwesomeIcons.solidBookmark,
                              color: AppColor.purple,
                              size: 20.r,
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
    );
  }
}
