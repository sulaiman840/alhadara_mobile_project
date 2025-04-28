
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  static const _menuItems = [
    _MenuItem(label: 'الهدايا',          icon: FontAwesomeIcons.gift,           route: AppRoutesNames.gifts),
    _MenuItem(label: 'الكورسات المكتملة', icon: FontAwesomeIcons.circleCheck,    route: AppRoutesNames.finishedCourses),
    _MenuItem(label: 'نتائج اختباري',    icon: FontAwesomeIcons.clipboardList,  route: AppRoutesNames.testResults),
    _MenuItem(label: 'الإعدادات',        icon: FontAwesomeIcons.gear,           route: AppRoutesNames.settings),
    _MenuItem(label: 'المساعدة والدعم',  icon: FontAwesomeIcons.circleQuestion, route: AppRoutesNames.complaints),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'الحساب',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              Row(
                children: [
                  // 1) Avatar (will sit at the far right)
                  CircleAvatar(
                    radius: 32.r,
                    backgroundImage: AssetImage('assets/images/man.png'),
                  ),

                  SizedBox(width: 16.w),

                  // 2) Name + joined date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'أحمد علي',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textDarkBlue,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'عضو منذ  1/1/2024',
                        style: TextStyle(fontSize: 12.sp, color: AppColor.gray3),
                      ),
                    ],
                  ),

                  Spacer(),

                  // 3) Logout button (far left)
                  ElevatedButton(
                    onPressed: () {
                      // TODO: perform logout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text('تسجيل خروج', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              Expanded(
                child: ListView.separated(
                  itemCount: _menuItems.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColor.gray3,
                    thickness: 0.2.h,
                    height: 16.h,
                  ),
                  itemBuilder: (context, idx) {
                    final item = _menuItems[idx];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(item.icon, color: AppColor.purple),
                      title: Text(
                        item.label,
                        style: TextStyle(fontSize: 16.sp, color: AppColor.textDarkBlue),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.r, color: AppColor.gray3),
                      onTap: () => context.go(item.route),
                    );
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

class _MenuItem {
  final String label;
  final IconData icon;
  final String route;
  const _MenuItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}
