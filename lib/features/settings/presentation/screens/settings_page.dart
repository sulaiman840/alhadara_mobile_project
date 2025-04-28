
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  static const _menuItems = [
  _MenuItem(label: 'تغيير اللغة',   icon: FontAwesomeIcons.language,           route: AppRoutesNames.language),
  _MenuItem(label: 'تغيير وضع العرض', icon: FontAwesomeIcons.circleHalfStroke,    route: AppRoutesNames.themeMode),
];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'الاعدادات',
          onBack: () => context.go(AppRoutesNames.menu_page),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
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
