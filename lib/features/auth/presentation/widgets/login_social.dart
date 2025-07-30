import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/localization/app_localizations.dart';
import 'or_divider.dart';

class LoginSocial extends StatelessWidget {
  const LoginSocial({super.key});

  @override
  Widget build(BuildContext context) {
    final loc   = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OrDivider(),
        SizedBox(height: 16.h),

        OutlinedButton.icon(
          onPressed: () {  },
          icon: FaIcon(
            FontAwesomeIcons.google,
            color: theme.colorScheme.primary,
            size: 20.r,
          ),
          label: Text(
            loc.tr('login_with_google'),
            style: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onBackground, fontSize: 16.sp),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            side: BorderSide(color: theme.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
