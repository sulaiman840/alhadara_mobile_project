import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

/// A drop-in replacement for AppBar that only shows a back arrow
/// when GoRouter.canPop() is true.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final double elevation;

  /// If you need to override the default `context.pop()` behavior,
  /// you can still pass your own [onBack]. Otherwise it will
  /// call `context.pop()`.
  final VoidCallback? onBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.backgroundColor,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = GoRouter.of(context).canPop();
    return AppBar(
      backgroundColor: backgroundColor ?? AppColor.background,
      elevation: elevation,
      centerTitle: true,
      // only provide a leading if there's somewhere to pop back to
      leading: canPop
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.textDarkBlue),
        onPressed: onBack ?? () => context.pop(),
      )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.textDarkBlue,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
