import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorText extends StatelessWidget {
  final String message;
  const ErrorText({required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
