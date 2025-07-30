import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/navigation/routes_names.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => context.push(AppRoutesNames.search),
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColor.gray3),
            SizedBox(width: 8.w),
            Text(loc.tr('search_courses'),
                style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(color: AppColor.gray3)),
          ],
        ),
      ),
    );
  }
}
