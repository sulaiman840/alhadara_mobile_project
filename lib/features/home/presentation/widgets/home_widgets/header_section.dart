import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/navigation/routes_names.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Row(
      children: [
        Text(
          loc.tr('home_welcome'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        _CircleIconButton(
          icon: FontAwesomeIcons.solidBell,
          onTap: () => context.push(AppRoutesNames.notifications),
        ),
        SizedBox(width: 12.w),
        _CircleAvatar(
          imagePath: 'assets/images/man.png',
          onTap: () => context.push(AppRoutesNames.profile),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = 40.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.purple, width: 1.5.r),
        ),
        child: Center(
          child: FaIcon(icon, size: 18.r, color: AppColor.textDarkBlue),
        ),
      ),
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;
  const _CircleAvatar({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = 40.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.purple, width: 2.r),
        ),
        child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
      ),
    );
  }
}
