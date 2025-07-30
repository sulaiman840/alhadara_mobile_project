import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CustomAppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final double elevation;
  final VoidCallback? onBack;

  const CustomAppBarTitle({
    super.key,
    required this.title,
    this.onBack,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = GoRouter.of(context).canPop();
    return AppBar(
      backgroundColor: backgroundColor
          ?? theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: elevation,
      centerTitle: true,

      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
