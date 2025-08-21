import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyAnswers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        context.trf('no_answers_yet', ar: 'لا توجد إجابات بعد', en: 'No answers yet'),
        style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
      ),
    );
  }
}
