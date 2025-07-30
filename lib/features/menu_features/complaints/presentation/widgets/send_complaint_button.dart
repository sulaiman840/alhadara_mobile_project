import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

class SendComplaintButton extends StatelessWidget {
  const SendComplaintButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: 48.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: loading
            ? SizedBox(
          width: 20.r,
          height: 20.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
          ),
        )
            : Icon(Icons.send, size: 20.r, color: theme.colorScheme.onPrimary),
        label: Text(
          loading ? loc.tr('sending') : loc.tr('send'),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }
}
