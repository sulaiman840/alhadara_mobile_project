import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const MenuOption({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.r, color: theme.dividerColor),
      onTap: onTap,
    );
  }
}
