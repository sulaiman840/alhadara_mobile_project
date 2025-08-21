import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/navigation/routes_names.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }

  Future<void> _loadUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _photoUrl = prefs.getString('user_photo') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc   = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          loc.tr('home_welcome'),
          style: theme.textTheme.titleLarge,
        ),
        const Spacer(),
        _CircleIconButton(
          icon: FontAwesomeIcons.solidBell,
          onTap: () => context.push(AppRoutesNames.notifications),
        ),
        SizedBox(width: 12.w),
        _CircleAvatar(
          photoUrl: _photoUrl,
          fallbackAsset: 'assets/images/man.png',
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
    final size  = 40.r;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.primary, width: 1.5.r),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.06),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Center(
          child: FaIcon(
            icon,
            size: 18.r,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  final String? photoUrl;
  final String fallbackAsset;
  final VoidCallback onTap;

  const _CircleAvatar({
    required this.photoUrl,
    required this.fallbackAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size  = 40.r;
    final theme = Theme.of(context);

    Widget _buildImage() {
      if (photoUrl != null && photoUrl!.isNotEmpty) {
        return Image.network(
          photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Image.asset(fallbackAsset, fit: BoxFit.cover),
        );
      }
      return Image.asset(fallbackAsset, fit: BoxFit.cover);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.primary, width: 2.r),
        ),
        child: ClipOval(child: _buildImage()),
      ),
    );
  }
}
