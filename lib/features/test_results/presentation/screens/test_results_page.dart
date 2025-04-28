// lib/features/tests/presentation/screens/test_results_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class TestResultsPage extends StatelessWidget {
  const TestResultsPage({Key? key}) : super(key: key);

  static const _results = [
    {
      'title': 'لغة انكليزية',
      'time': '2/2/2024',
      'author': ' علي أحمد',
      'score': '95%',
    },
    {
      'title': 'لغة المانية',
      'time': '2/2/2024',
      'author': ' علي أحمد',
      'score': '50%',
    },
  ];

  Widget _buildScoreBadge(String score) {
    final pct = double.parse(score.replaceAll('%', '')) / 100;
    return CircularPercentIndicator(
      radius: 40.r,
      lineWidth: 8.r,
      percent: pct,
      backgroundColor: AppColor.purple.withValues(alpha: 0.2),
      progressColor: AppColor.purple,
      center: Text(
        score,
        style: TextStyle(
          color: AppColor.textDarkBlue,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      animation: true,
      animationDuration: 800,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'نتائج الاختبارات',
          onBack: () => context.go(AppRoutesNames.menu_page),
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          itemCount: _results.length,
          separatorBuilder: (_, __) => SizedBox(height: 24.h),
          itemBuilder: (ctx, idx) {
            final r = _results[idx];
            return Card(
              color: AppColor.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              shadowColor: AppColor.gray3.withValues(alpha: 0.2),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,   // enough vertical space
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1) Badge on the right (start in RTL)
                    _buildScoreBadge(r['score']!),
                    SizedBox(width: 16.w),

                    // 2) Text expands
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r['title']!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textDarkBlue,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${r['time']} • ${r['author']}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColor.gray3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3) Chevron
                    Icon(
                      Icons.chevron_left,
                      size: 24.r,
                      color: AppColor.gray3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
