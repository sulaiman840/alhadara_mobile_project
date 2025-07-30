import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../data/settings_option.dart';
import '../widgets/settings_tile.dart';
import '../../../../../shared/widgets/app_bar/custom_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _options = [
    SettingsOption(
      'settings_language',
      FontAwesomeIcons.language,
      AppRoutesNames.language,
    ),
    SettingsOption(
      'settings_theme_mode',
      FontAwesomeIcons.circleHalfStroke,
      AppRoutesNames.themeMode,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: loc.tr('settings_title')),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        itemCount: _options.length,
        separatorBuilder: (_, __) =>  Divider(
          color: Theme.of(context).dividerColor,
          thickness: 0.2.h,
          height: 16.h,
        ),
        itemBuilder: (ctx, i) {
          final opt = _options[i];
          return SettingsTile(
            icon: opt.icon,
            title: loc.tr(opt.labelKey),
            onTap: () => context.push(opt.route),
          );
        },
      ),
    );
  }
}
