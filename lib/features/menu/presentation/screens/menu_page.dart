import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/logout_cubit/logout_cubit.dart';
import '../../cubit/logout_cubit/logout_state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _name      = '';
  String _photoUrl  = '';
  String _createdAt = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfoFromPrefs();
  }

  Future<void> _loadUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name      = prefs.getString('user_name') ?? '';
      _photoUrl  = prefs.getString('user_photo') ?? '';
      _createdAt = prefs.getString('user_created_at') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          GoRouter.of(context).go(AppRoutesNames.login);
        }
        if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColor.background,
          appBar: CustomAppBar(
            title: 'الحساب',
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // ◀ Change here ▶
                        CircleAvatar(
                          radius: 32.r,
                          backgroundImage: (_photoUrl.isNotEmpty)
                              ? NetworkImage(_photoUrl)
                              : AssetImage('assets/images/man.png')
                          as ImageProvider,
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Display real name:
                            Text(
                              _name.isNotEmpty ? _name : '...',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.textDarkBlue,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            // Display “Member since YYYY/MM/DD”
                            Text(
                              _createdAt.isNotEmpty
                                  ? 'عضو منذ ${_formatDate(_createdAt)}'
                                  : '...',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColor.gray3,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () => _showLogoutConfirmDialog(context),
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
                              style: TextStyle(
                                  fontSize: 16.sp, color: AppColor.textDarkBlue),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.r,
                              color: AppColor.gray3,
                            ),
                            onTap: () => context.push(item.route),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<LogoutCubit, LogoutState>(
                builder: (context, state) {
                  if (state is LogoutLoading) {
                    return const LoadingOverlay(
                      message: 'جارٍ تسجيل الخروج...',
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.year}/${_twoDigits(dt.month)}/${_twoDigits(dt.day)}';
    } catch (_) {
      return isoString.split('T').first;
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تأكيد تسجيل الخروج',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟',
                style: TextStyle(fontSize: 16.sp)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text('إلغاء',
                    style: TextStyle(fontSize: 16.sp, color: AppColor.gray3)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                  context.read<LogoutCubit>().logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r)),
                ),
                child: Text('تأكيد',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ),
            ],
          ),
        );
      },
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

const _menuItems = [
  _MenuItem(label: 'الهدايا', icon: FontAwesomeIcons.gift, route: AppRoutesNames.gifts),
  _MenuItem(label: 'اعلانات المعهد', icon: FontAwesomeIcons.circleCheck, route: AppRoutesNames.activeAds),
  _MenuItem(label: 'نتائج اختباري', icon: FontAwesomeIcons.clipboardList, route: AppRoutesNames.testResults),
  _MenuItem(label: 'الإعدادات', icon: FontAwesomeIcons.gear, route: AppRoutesNames.settings),
  _MenuItem(label: 'المساعدة والدعم', icon: FontAwesomeIcons.circleQuestion, route: AppRoutesNames.complaints),
];
