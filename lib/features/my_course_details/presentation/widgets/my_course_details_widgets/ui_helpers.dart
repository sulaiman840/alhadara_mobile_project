import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/app_localizations.dart';

class UiHelpers {
  static String safeTr(AppLocalizations loc, String key, {required String fallback}) {
    try {
      final v = loc.tr(key);
      if (v == key || v.isEmpty) return fallback;
      return v;
    } catch (_) {
      return fallback;
    }
  }

  static Widget placeholderBanner(double height, ThemeData theme) => Container(
    width: double.infinity,
    height: height,
    color: theme.colorScheme.surface,
    child: Icon(
      Icons.broken_image,
      size: 40.r,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
    ),
  );
}