import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColor.purple,
      secondary: AppColor.orange,
      surface: AppColor.background,
      onSurface: AppColor.textDarkBlue,
      error: AppColor.red,
    ),
    scaffoldBackgroundColor: AppColor.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.background,
      foregroundColor: AppColor.textDarkBlue,
      elevation: 0,
    ),
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColor.textDarkBlue, fontSize: 16),
      bodyMedium: TextStyle(color: AppColor.textDarkBlue.withValues(alpha: 0.8), fontSize: 14),
      bodySmall: TextStyle(color: AppColor.textDarkBlue.withValues(alpha:0.6), fontSize: 12),
      titleLarge: TextStyle(color: AppColor.textDarkBlue, fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: AppColor.textDarkBlue, fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColor.purple2,
      secondary: AppColor.orange,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
      error: AppColor.red,
    ),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF2A2A2A),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
      bodySmall: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
      titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
