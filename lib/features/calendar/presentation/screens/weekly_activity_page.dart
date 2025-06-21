import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/shared/widgets/custom_app_bar.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/features/calendar/cubit/schedule_cubit.dart';
import 'package:alhadara_mobile_project/features/calendar/cubit/schedule_state.dart';

import '../../../../core/utils/const.dart';

class WeeklyActivityPage extends StatefulWidget {
  const WeeklyActivityPage({Key? key}) : super(key: key);

  @override
  State<WeeklyActivityPage> createState() => _WeeklyActivityPageState();
}

class _WeeklyActivityPageState extends State<WeeklyActivityPage> {
  // Arabic labels for each day:
  final List<String> _daysAr   = ['سبت','أحد','اثنين','ثلاثاء','أربعاء','خميس','جمعة'];
  // Corresponding slugs for your API:
  final List<String> _daysSlug = [
    'saturday','sunday','monday','tuesday','wednesday','thursday','friday'
  ];
  // which day is selected (0 = Saturday)
  int _selectedIndex = DateTime.now().weekday % 7;
  @override
  void initState() {
    super.initState();
    // Fetch “today” on first build:
    final todayIndex = DateTime.now().weekday % 7;
    context.read<ScheduleCubit>().fetchByDay(_daysSlug[todayIndex]);
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScheduleCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'النشاط التعليمي',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header Row ─────────────────────────
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

                ],
              ),

              SizedBox(height: 16.h),

              // ── Days Selector ───────────────────────
              SizedBox(
                height: 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _daysAr.length,
                  itemBuilder: (_, i) {
                    final selected = i == _selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedIndex = i);
                        cubit.fetchByDay(_daysSlug[i]);
                      },
                      child: Container(
                        width: 50.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          color: selected ? AppColor.purple : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _daysAr[i],
                          style: TextStyle(
                            color: selected ? Colors.white : AppColor.textDarkBlue,
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
                'هذا اليوم',
                style: TextStyle(
                  fontSize: 22,
                  color: AppColor.textDarkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12.h),

              // ── Schedule List ───────────────────────
              Expanded(
                child: BlocBuilder<ScheduleCubit, ScheduleState>(
                  builder: (_, state) {
                    if (state is ScheduleLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ScheduleError) {
                      return Center(child: Text('حدث خطأ: ${state.message}'));
                    }
                    if (state is ScheduleLoaded) {
                      final events = state.events;
                      if (events.isEmpty) {
                        return const Center(child: Text('لا يوجد دورات في هذا اليوم',style:TextStyle(color: AppColor.textDarkBlue) ,));
                      }
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        itemCount: events.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (_, idx) {
                          final e = events[idx];
                          return Card(
                            color: AppColor.purple,
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
                                    child: Image.network(
                                      '${ConstString.baseURl}${e.course.photo}',
                                      width: 80.w,
                                      height: 80.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 80.w,
                                        height: 80.h,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${e.startTime.substring(0,5)} – ${e.endTime.substring(0,5)}',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12.sp,
                                          ),
                                        ),

                                        SizedBox(height: 4.h),
                                        Text(
                                          e.course.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          e.sectionName,
                                          style: TextStyle(
                                            color: Colors.white70,
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
                      );
                    }
                    return const SizedBox.shrink();
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
