import 'package:alhadara_mobile_project/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  void _onNext() {
    if (_currentIndex < 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      GoRouter.of(context).go(AppRoutesNames.login);
    }
  }

  Widget _buildPage({
    required IconData icon,
    required String imageAsset,
    required String text,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          icon,
          size: 80.r,
          color: AppColor.purple,
        ),
        SizedBox(height: 100.h),
        Image.asset(
          imageAsset,
          width: 350.w,
          height: 300.w,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.textDarkBlue,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.purple3,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: [
                  _buildPage(
                    icon: FontAwesomeIcons.graduationCap,
                    imageAsset: 'assets/images/girl.png',
                    text: 'اجعل التعلم افضل مع تطبيقنا',
                  ),
                  _buildPage(
                    icon: FontAwesomeIcons.graduationCap,
                    imageAsset: 'assets/images/image1.png',
                    text: 'أهلا بك في معهد الحضارة',
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (i) {
                  final selected = i == _currentIndex;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: selected ? 15.w : 9.w,
                    height: selected ? 15.w : 9.w,
                    decoration: BoxDecoration(
                      color: selected ? AppColor.purple : AppColor.purple2,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'التالي',
              onPressed: _onNext,
              horizontalPadding: 32.w,
              height: 48.h,
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
