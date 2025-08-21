import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';

class ForumCta extends StatelessWidget {
  final int sectionId;
  final double height;

  const ForumCta({super.key, required this.sectionId, required this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Center(
      child: SizedBox(
        width: 250.w,
        height: height,
        child: OutlinedButton(
          onPressed: () {
            context.pushNamed(
              'forum',
              pathParameters: {'sectionId': sectionId.toString()},
            );
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            side: BorderSide(color: theme.colorScheme.primary, width: 2.r),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          child: Text(
            loc.tr('forum_button'),
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
