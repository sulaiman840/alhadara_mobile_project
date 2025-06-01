
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

import '../../cubit/grades_cubit.dart';
import '../../cubit/grades_state.dart';


class TestResultsPage extends StatelessWidget {
  const TestResultsPage({Key? key}) : super(key: key);

  Widget _buildScoreBadge(double grade) {
    final pct = (grade / 100).clamp(0.0, 1.0);
    final scoreText = "${grade.toStringAsFixed(1)}%";
    return CircularPercentIndicator(
      radius: 40.r,
      lineWidth: 8.r,
      percent: pct,
      backgroundColor: AppColor.purple.withValues(alpha: 0.2),
      progressColor: AppColor.purple,
      center: Text(
        scoreText,
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

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return iso.split('T').first; // fallback
    }
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
        body: BlocBuilder<GradesCubit, GradesState>(
          builder: (context, state) {
            if (state is GradesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GradesError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: TextStyle(
                    color: AppColor.textDarkBlue,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is GradesLoaded) {
              final grades = state.grades;
              if (grades.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد نتائج متاحة',
                    style: TextStyle(
                      color: AppColor.textDarkBlue,
                      fontSize: 16.sp,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                itemCount: grades.length,
                separatorBuilder: (_, __) => SizedBox(height: 24.h),
                itemBuilder: (ctx, idx) {
                  final item = grades[idx];
                  final sectionName = item.section.name;
                  final examDateStr = _formatDate(item.examDate);
                  final trainerName = item.trainer.name;
                  final notes = item.notes;

                  return Card(
                    color: AppColor.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    shadowColor: AppColor.gray3.withOpacity(0.2),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1) Score badge
                          _buildScoreBadge(item.grade),
                          SizedBox(width: 16.w),

                          // 2) Text column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sectionName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.textDarkBlue,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '$examDateStr • $trainerName',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColor.gray3,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '$notes ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColor.gray3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 3) Chevron (RTL)
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
              );
            } else {
              // state is GradesInitial
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
