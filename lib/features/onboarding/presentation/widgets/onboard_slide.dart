import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

import '../../data/models/onboard_slide.dart';

class OnboardSlideWidget extends StatelessWidget {
  final OnboardSlide slide;

  const OnboardSlideWidget({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(slide.icon, size: 80.r, color: AppColor.purple),
        SizedBox(height: 100.h),
        Image.asset(
          slide.imageAsset,
          width: 350.w,
          height: 300.w,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            loc.tr(slide.textKey),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
