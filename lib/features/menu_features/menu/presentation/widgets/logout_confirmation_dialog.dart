import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../cubit/logout_cubit/logout_cubit.dart';

class LogoutConfirmationDialog {
  static Future<void> show(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(loc.tr('logout_confirm_title'),
              style: TextStyle(fontSize: 18.sp)),
          content: Text(loc.tr('logout_confirm_message'),
              style: TextStyle(fontSize: 16.sp)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(loc.tr('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                context.read<LogoutCubit>().logout();
              },
              child: Text(loc.tr('confirm'),
                  style: TextStyle(fontSize: 16.sp, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
