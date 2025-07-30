import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/shared/widgets/buttons/custom_button.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../data/models/onboard_slide.dart';
import '../widgets/onboard_slide.dart';
import '../widgets/dots_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentIndex = 0;

  final _slides = const <OnboardSlide>[
    OnboardSlide(
      icon: FontAwesomeIcons.graduationCap,
      imageAsset: 'assets/images/girl.png',
      textKey: 'onboarding_slide1',
    ),
    OnboardSlide(
      icon: FontAwesomeIcons.graduationCap,
      imageAsset: 'assets/images/image1.png',
      textKey: 'onboarding_slide2',
    ),
  ];

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      GoRouter.of(context).go(AppRoutesNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColor.purple3,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (_, i) => OnboardSlideWidget(slide: _slides[i]),
              ),
            ),

            // dots
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: DotsIndicator(
                count: _slides.length,
                currentIndex: _currentIndex,
              ),
            ),

            // next button
            CustomButton(
              text: loc.tr('onboarding_next'),
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
