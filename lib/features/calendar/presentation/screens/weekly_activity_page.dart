import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class WeeklyActivityPage extends StatefulWidget {
  const WeeklyActivityPage({Key? key}) : super(key: key);

  @override
  _WeeklyActivityPageState createState() => _WeeklyActivityPageState();
}

class _WeeklyActivityPageState extends State<WeeklyActivityPage> {
  final _days = ['سبت', 'أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة'];
  int _selectedDayIndex = DateTime.now().weekday % 7; // السبت=0

  // بيانات وهمية للنشاط
  final List<Map<String, String>> _activities = [
    {
      'date': 'السبت 25',
      'image': 'assets/images/English.jpg',
      'title': 'كورس لغة انجليزية: للمبتدئين',
      'subtitle': ' أ. مريم',
    },
    {
      'date': 'السبت 28',
      'image': 'assets/images/English.jpg',
      'title': 'كورس لغة انجليزية: للمبتدئين',
      'subtitle': ' أ. مريم',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'النشاط التعليمي',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'النشاط الأسبوعي',
                    style: TextStyle(
                      color: AppColor.textDarkBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go(AppRoutesNames.calendar);
                    },
                    borderRadius: BorderRadius.circular(4.r),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      child: Row(
                        children: [
                          Text(
                            'المزيد',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: AppColor.textDarkBlue,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14.r,
                            color: AppColor.textDarkBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              SizedBox(
                height: 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (ctx, i) {
                    final selected = i == _selectedDayIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDayIndex = i),
                      child: Container(
                        width: 50.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColor.purple : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _days[i],
                          style: TextStyle(
                            color:
                                selected ? Colors.white : AppColor.textDarkBlue,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 24.h),
              const Text(
                'هذا الأسبوع',
                style: TextStyle(
                  fontSize: 22,
                  color: AppColor.textDarkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),

              Expanded(
                child: ListView.separated(
                  itemCount: _activities.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (ctx, idx) {
                    final a = _activities[idx];
                    return Card(color:  AppColor.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                a['image']!,
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a['date']!,
                                    style: TextStyle(
                                      color: AppColor.gray3,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    a['title']!,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    a['subtitle']!,
                                    style: TextStyle(
                                      color: AppColor.gray3,
                                      fontSize: 12.sp,
                                    ),
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
    );
  }
}
