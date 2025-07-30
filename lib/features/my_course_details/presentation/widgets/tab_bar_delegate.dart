import 'package:flutter/material.dart';

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final List<Tab> tabs;
  final bool pinned;

  TabBarDelegate({required this.tabs, required this.pinned});

  @override
  double get minExtent => tabs.first.preferredSize.height;
  @override
  double get maxExtent => tabs.first.preferredSize.height;

  @override
  Widget build(BuildContext context, double _, bool overlapsContent) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: pinned ? 1.0 : 0.5,
      child: Material(
        color: theme.colorScheme.surface,
        elevation: overlapsContent ? 4 : 0,
        child: TabBar(          dividerColor:  theme.colorScheme.surface,

          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor:
          theme.colorScheme.onSurface.withValues(alpha: 0.8),
          tabs: tabs,
          labelStyle: theme.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant TabBarDelegate old) =>
      old.pinned != pinned || old.tabs != tabs;
}
