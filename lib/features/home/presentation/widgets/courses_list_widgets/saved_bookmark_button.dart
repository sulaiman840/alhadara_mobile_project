import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SavedBookmarkButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const SavedBookmarkButton({
    super.key,
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: FaIcon(
        isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
        size: 20.r,
        color: isSaved ? scheme.primary : scheme.outline,
      ),
    );
  }
}
