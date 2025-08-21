import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCourseSquareImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;

  const MyCourseSquareImage({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) => Container(
          width: size,
          height: size,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          child: Icon(
            Icons.broken_image,
            size: 24.r,
            color: theme.colorScheme.outline,
          ),
        ),
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return Container(
            width: size,
            height: size,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}
