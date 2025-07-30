import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/locale_cubit.dart';
import '../../data/lang_option.dart';
import '../widgets/option_tile.dart';


class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  static const _langs = [
    LangOption('ar', '🇸🇦', 'language_ar'),
    LangOption('en', '🇺🇸', 'language_en'),
  ];

  @override
  Widget build(BuildContext context) {
    final loc     = AppLocalizations.of(context);
    final current = context.select((LocaleCubit c) => c.state.languageCode);

    return Scaffold(
      appBar: CustomAppBar(title: loc.tr('language_selection')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 44.h, horizontal: 16.w),
        children: [
          for (final opt in _langs)
            OptionTile(
              leading: Text(opt.flag, style: TextStyle(fontSize: 28.sp)),
              label:   loc.tr(opt.labelKey),
              selected: opt.code == current,
              onTap:    () => context.read<LocaleCubit>().setLocale(opt.code),
            ),
        ],
      ),
    );
  }
}
