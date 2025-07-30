import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/const.dart';


class AdImage extends StatelessWidget {
  final String photoPath;
  const AdImage({super.key, required this.photoPath});

  @override
  Widget build(BuildContext context) {
    final url = '${ConstString.baseURl}$photoPath';
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: Image.network(
        url,
        height: 160.h,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, prog) {
          if (prog == null) return child;
          return Container(
            height: 160.h,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: prog.expectedTotalBytes != null
                    ? prog.cumulativeBytesLoaded /
                    prog.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: 160.h,
          color: Colors.grey[200],
          child: Icon(
            Icons.broken_image,
            size: 48.r,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
