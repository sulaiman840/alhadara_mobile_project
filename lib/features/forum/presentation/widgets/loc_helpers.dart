import 'package:flutter/widgets.dart';
import '../../../../core/localization/app_localizations.dart';

bool _isArabicLocale(Locale locale) =>
    locale.languageCode.toLowerCase().startsWith('ar');


String trWithFallback(
    AppLocalizations loc,
    String key, {
      required String ar,
      required String en,
    }) {
  try {
    final v = loc.tr(key);
    if (v.isNotEmpty && v != key) return v;
  } catch (_) {}
  return _isArabicLocale(loc.locale) ? ar : en;
}

extension L10nBuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get isAr => _isArabicLocale(Localizations.localeOf(this));
  TextDirection get dir => isAr ? TextDirection.rtl : TextDirection.ltr;

  String trf(String key, {required String ar, required String en}) =>
      trWithFallback(l10n, key, ar: ar, en: en);
}
