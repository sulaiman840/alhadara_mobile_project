import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.primary, size: 24.r),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.r,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      onTap: onTap,
    );
  }
}
