import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewQuestionDialog extends StatefulWidget {
  const NewQuestionDialog({super.key});

  @override
  State<NewQuestionDialog> createState() => _NewQuestionDialogState();
}

class _NewQuestionDialogState extends State<NewQuestionDialog> {
  late final TextEditingController _ctl = TextEditingController();

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: context.dir,
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          context.trf('forum_new_question_title',
              ar: 'إنشاء سؤال جديد', en: 'Create a new question'),
          style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
        ),
        content: TextField(
          controller: _ctl,
          maxLines: 3,
          cursorColor: scheme.primary,
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            labelText: context.trf('forum_question_content',
                ar: 'محتوى السؤال', en: 'Question content'),
            labelStyle: textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: scheme.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.trf('cancel', ar: 'إلغاء', en: 'Cancel'),
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            ),
            onPressed: () => Navigator.pop(context, _ctl.text),
            child: Text(
              context.trf('forum_post', ar: 'نشر', en: 'Post'),
              style: textTheme.bodyMedium?.copyWith(color: scheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
