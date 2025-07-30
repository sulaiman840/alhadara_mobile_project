import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _languageKey = 'app_language';

  LocaleCubit() : super(const Locale('ar')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code  = prefs.getString(_languageKey) ?? 'ar';
    emit(Locale(code));
  }

  Future<void> setLocale(String code) async {
    emit(Locale(code));
    (await SharedPreferences.getInstance())
        .setString(_languageKey, code);
  }
}
