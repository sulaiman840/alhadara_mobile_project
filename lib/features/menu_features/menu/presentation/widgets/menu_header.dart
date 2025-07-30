import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';

class MenuHeader extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String createdAt;
  final VoidCallback onLogout;

  const MenuHeader({
    required this.name,
    required this.photoUrl,
    required this.createdAt,
    required this.onLogout,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc   = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final displayDate = _formatDate(createdAt);

    return Row(
      children: [
        CircleAvatar(
          radius: 32.r,
          backgroundImage: photoUrl.isNotEmpty
              ? NetworkImage(photoUrl)
              : const AssetImage('assets/images/man.png') as ImageProvider,
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              name.isNotEmpty ? name : '...',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              createdAt.isNotEmpty
                  ? '${loc.tr("member_since")} $displayDate'
                  : '...',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColor.gray3,
              ),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          child: Text(
            loc.tr('logout'),
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.year}/${dt.month.toString().padLeft(2,'0')}/${dt.day.toString().padLeft(2,'0')}';
    } catch (_) {
      return iso.split('T').first;
    }
  }
}
