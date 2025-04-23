import 'package:flutter/material.dart';

class LocalizationService {
  static const Locale fallbackLocale = Locale('en', 'US');
  static const List<Locale> supportedLocales = [Locale('en', 'US'), Locale('es', 'ES')];
  static Locale get deviceLocale => WidgetsBinding.instance.window.locale;
  static const Iterable<LocalizationsDelegate<dynamic>> delegates = [];
// TODO: add intl or flutter_localizations delegates
}