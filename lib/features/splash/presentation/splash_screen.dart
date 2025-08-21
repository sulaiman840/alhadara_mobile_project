import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/navigation/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _kSeenOnboarding = 'seen_onboarding';

  @override
  void initState() {
    super.initState();
    _decideStartDestination();
  }

  Future<void> _decideStartDestination() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool(_kSeenOnboarding) ?? false;
    final token = prefs.getString('access_token');

    // Small visual pause; optional
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    if (!seenOnboarding) {
      context.go(AppRoutesNames.OnboardingScreen);
      return;
    }

    if (token != null && token.isNotEmpty) {
      context.go(AppRoutesNames.home);
    } else {
      context.go(AppRoutesNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.purple,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.044,
              child: Image.asset(
                'assets/images/doodle.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: const [
                    Color.fromRGBO(255, 255, 255, 0.30),
                    Color.fromRGBO(255, 255, 255, 0.00),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
              child: Center(
                child: Container(
                  width: 350.w,
                  height: 180.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.purple2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.graduationCap,
                        size: 75.r,
                        color: AppColor.white,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'الحضارة',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
