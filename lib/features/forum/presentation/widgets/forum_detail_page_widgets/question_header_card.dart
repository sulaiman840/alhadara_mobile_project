import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/const.dart';

class QuestionHeaderCard extends StatelessWidget {
  final dynamic question; // replace with your Question model if available
  const QuestionHeaderCard({required this.question});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2)),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(
                    '${ConstString.baseURl}${question.user.photo}',
                  ),
                  backgroundColor: scheme.primary.withOpacity(0.1),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    question.user.name,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              question.content,
              style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
