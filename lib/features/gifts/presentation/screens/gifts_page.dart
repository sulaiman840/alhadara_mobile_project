import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'الهدايا',
          onBack: () => context.go(AppRoutesNames.menu_page),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GiftCard(
                title: 'شيك بقيمة 200 ألف ليرة',
                dateLabel: '23/3/2024',
                courseInfo: 'كورس البرمجة',
                icon: FontAwesomeIcons.graduationCap,
              ),
              SizedBox(height: 16.h),
              GiftCard(
                title: 'شيك بقيمة 300 ألف ليرة',
                dateLabel: '2/2/2024',
                courseInfo: 'كورس فلاتر للمبتدئين',
                icon: FontAwesomeIcons.graduationCap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GiftCard extends StatelessWidget {
  final String title;
  final String dateLabel;
  final String courseInfo;
  final IconData icon;

  const GiftCard({
    required this.title,
    required this.dateLabel,
    required this.courseInfo,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // right‐aligned in RTL
        children: [
          // ── Top Row: icon on right, then title ─────────────────
          Row(
            children: [
              // 1) The round icon on the right edge
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: AppColor.purple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(icon, size: 33.r, color: AppColor.purple),
                ),
              ),
              SizedBox(width: 12.w),

              // 2) Title fills the rest
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDarkBlue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Metadata Row ────────────────────────────────────────
          Row(
            children: [
              SizedBox(width: 10.w),
              Text(
                courseInfo,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.gray3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 30.w),
              Expanded(
                child: Text(
                  dateLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.gray3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
