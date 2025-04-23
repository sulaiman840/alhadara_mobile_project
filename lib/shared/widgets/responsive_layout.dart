import 'package:flutter/widgets.dart';

import '../../core/utils/breakpoints.dart';


class ResponsiveLayout extends StatelessWidget {
  final Widget small;
  final Widget medium;
  final Widget large;

  const ResponsiveLayout({Key? key, required this.small, required this.medium, required this.large}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ScreenLayout.isSmall(context)) return small;
    if (ScreenLayout.isMedium(context)) return medium;
    return large;
  }
}


class ScreenLayout {
  static bool isSmall(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w < Breakpoints.medium;
  }
  static bool isMedium(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= Breakpoints.medium && w < Breakpoints.large;
  }
  static bool isLarge(BuildContext context) => MediaQuery.of(context).size.width >= Breakpoints.large;
}