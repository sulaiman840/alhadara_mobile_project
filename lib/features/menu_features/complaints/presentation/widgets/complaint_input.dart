import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

class ComplaintInput extends StatelessWidget {
  const ComplaintInput({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: 3,
      cursorColor: theme.colorScheme.onSurface,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: loc.tr('complaint_hint'),
        hintStyle: theme.textTheme.bodySmall,
        filled: true,
        fillColor: theme.cardColor,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
