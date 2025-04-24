import 'dart:async';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      GoRouter.of(context).go(AppRoutesNames.home,);
    });
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
                  stops: [0.5, 1.0],
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
                      // 6. Arabic text
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
