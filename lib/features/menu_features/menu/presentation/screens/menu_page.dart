import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/shared/widgets/loading_overlay.dart';
import '../../../../../core/navigation/routes_names.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../shared/widgets/app_bar/custom_app_bar_title.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_option.dart';
import '../widgets/logout_confirmation_dialog.dart';
import '../../data/menu_item.dart';
import '../../cubit/logout_cubit/logout_cubit.dart';
import '../../cubit/logout_cubit/logout_state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _name = '', _photoUrl = '', _createdAt = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name      = prefs.getString('user_name')       ?? '';
      _photoUrl  = prefs.getString('user_photo')      ?? '';
      _createdAt = prefs.getString('user_created_at') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc   = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final items = const [
      MenuItemData(FontAwesomeIcons.gift,           'menu_gifts',        AppRoutesNames.gifts),
      MenuItemData(FontAwesomeIcons.bullhorn, 'menu_active_ads', AppRoutesNames.activeAds),
      MenuItemData(FontAwesomeIcons.clipboardList, 'menu_test_results', AppRoutesNames.testResults),
      MenuItemData(FontAwesomeIcons.circleCheck,          'finished_courses_title',     AppRoutesNames.finishedCourses),
      MenuItemData(FontAwesomeIcons.gear,          'menu_settings',     AppRoutesNames.settings),
      MenuItemData(FontAwesomeIcons.circleQuestion,'menu_help_support', AppRoutesNames.complaints),
    ];

    return BlocListener<LogoutCubit, LogoutState>(
      listener: (ctx, state) {
        if (state is LogoutSuccess) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(loc.tr('logout_success')),
            backgroundColor: AppColor.green,
          ));
          GoRouter.of(ctx).go(AppRoutesNames.login);
        }
        if (state is LogoutFailure) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
            backgroundColor: theme.colorScheme.error,
          ));
        }
      },
      child: Stack(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: CustomAppBarTitle(title: loc.tr('menu_title')),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    MenuHeader(
                      name:      _name,
                      photoUrl:  _photoUrl,
                      createdAt: _createdAt,
                      onLogout:  () => LogoutConfirmationDialog.show(context),
                    ),
                    SizedBox(height: 32.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => Divider(
                          color: AppColor.gray3,
                          thickness: 0.2.h,
                          height: 16.h,
                        ),
                        itemBuilder: (ctx, i) {
                          final item = items[i];
                          return MenuOption(
                            icon:  item.icon,
                            title: loc.tr(item.labelKey),
                            onTap: () => context.push(item.route),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BlocBuilder<LogoutCubit, LogoutState>(
            builder: (ctx, state) =>
            state is LogoutLoading ? const LoadingOverlay() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
