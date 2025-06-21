import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../home/data/models/course_model.dart';
import '../../data/models/section_model.dart';
import '../../cubit/sections_cubit.dart';

class SectionsPage extends StatefulWidget {
  final CourseModel course;
  final String deptName;

  const SectionsPage({
    Key? key,
    required this.course,
    required this.deptName,
  }) : super(key: key);

  @override
  _SectionsPageState createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger load:
    context.read<SectionsCubit>().fetchSections(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'الشُعب المتاحة للكورس',
        ),
        backgroundColor: AppColor.background,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: BlocBuilder<SectionsCubit, SectionsState>(
            builder: (context, state) {
              if (state is SectionsLoading || state is SectionsInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SectionsFailure) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is SectionsSuccess) {
                final List<SectionModel> sections = state.sections;
                if (sections.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد شعب متاحة حاليًا',
                      style: TextStyle(fontSize: 16.sp, color: AppColor.textDarkBlue),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: sections.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final sec = sections[index];
                    return _buildSectionCard(sec);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(SectionModel sec) {
    // Format date range:
    final dateRange =
        '${sec.startDate.day}/${sec.startDate.month}/${sec.startDate.year}  -  '
        '${sec.endDate.day}/${sec.endDate.month}/${sec.endDate.year}';

    // Build weekdays string:
    final weekdaysText = sec.weekDays.isEmpty
        ? 'لا يوجد مواعيد محددة'
        : sec.weekDays
        .map((wd) =>
    '${wd.name} (${wd.startTime.substring(0, 5)} - ${wd.endTime.substring(0, 5)})')
        .join('، ');

    // Trainer names (or “لا يوجد مدرب”):
    final trainersText = sec.trainers.isEmpty
        ? 'لا يوجد مدرب محدد'
        : sec.trainers.map((t) => t.name).join('، ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section name & state badge
          Row(
            children: [
              Expanded(
                child: Text(
                  sec.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDarkBlue,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: sec.state == 'pending'
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  sec.state,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: sec.state == 'pending' ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Date range
          Row(
            children: [
              FaIcon(FontAwesomeIcons.calendarDays, size: 14.r, color: AppColor.gray3),
              SizedBox(width: 6.w),
              Text(
                dateRange,
                style: TextStyle(
                    fontSize: 14.sp, color: AppColor.textDarkBlue.withOpacity(0.8)),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Seats info
          Row(
            children: [
              FaIcon(FontAwesomeIcons.chair, size: 14.r, color: AppColor.gray3),
              SizedBox(width: 6.w),
              Text(
                'مقاعد: ${sec.reservedSeats}/${sec.seatsOfNumber}',
                style: TextStyle(
                    fontSize: 14.sp, color: AppColor.textDarkBlue.withOpacity(0.8)),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Trainers
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FaIcon(FontAwesomeIcons.userTie, size: 14.r, color: AppColor.gray3),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'المدربون: $trainersText',
                  style: TextStyle(
                      fontSize: 14.sp, color: AppColor.textDarkBlue.withOpacity(0.8)),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Weekdays / times
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FaIcon(FontAwesomeIcons.clock, size: 14.r, color: AppColor.gray3),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'الأيام: $weekdaysText',
                  style: TextStyle(
                      fontSize: 14.sp, color: AppColor.textDarkBlue.withOpacity(0.8)),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Register button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // Call Cubit.registerIntoSection(...) and await the Arabic message
                final message =
                await context.read<SectionsCubit>().registerIntoSection(sec.id);

                // If the message contains the word "نجاح" (success), show green;
                // otherwise, default to red (or fallback).
                final isSuccess = message.contains('نجاح');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor:
                    isSuccess ? Colors.green : Colors.redAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'تسجيل',
                style: TextStyle(
                    fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
