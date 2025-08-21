import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseImageCourseListWidget extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;

  const CourseImageCourseListWidget({
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
        errorBuilder: (ctx, err, stack) => Container(
          width: size,
          height: size,
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                    (progress.expectedTotalBytes!)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
