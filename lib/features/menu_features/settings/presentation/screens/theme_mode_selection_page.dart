import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/theme_cubit.dart';
import '../../data/mode_option.dart';
import '../widgets/option_tile.dart';


class ThemeModeSelectionPage extends StatelessWidget {
  const ThemeModeSelectionPage({super.key});

  static const _options = [
    ModeOption(ThemeMode.light, Icons.wb_sunny_rounded, 'theme_light'),
    ModeOption(ThemeMode.dark,  Icons.nights_stay_rounded, 'theme_dark'),
  ];

  @override
  Widget build(BuildContext context) {
    final loc  = AppLocalizations.of(context);
    final mode = context.select((ThemeCubit c) => c.state);

    return Scaffold(
      appBar: CustomAppBar(title: loc.tr('theme_selection')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 44.h, horizontal: 16.w),
        children: [
          for (final opt in _options)
            OptionTile(
              leading: Icon(opt.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28.r),
              label:    loc.tr(opt.labelKey),
              selected: opt.mode == mode,
              onTap:    () => context.read<ThemeCubit>().setMode(opt.mode),
            ),
        ],
      ),
    );
  }
}
