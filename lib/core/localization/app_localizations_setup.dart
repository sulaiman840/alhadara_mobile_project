import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

class AppLocalizationsSetup {
  static const delegates = <LocalizationsDelegate<dynamic>>[
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  static Locale? localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale != null) {
      for (final supported in supportedLocales) {
        if (supported.languageCode == locale.languageCode) {
          return supported;
        }
      }
    }
    return supportedLocales.first;
  }
}