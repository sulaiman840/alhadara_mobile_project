import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: context.dir,
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          context.trf('forum_delete_question_title',
              ar: 'حذف السؤال؟', en: 'Delete question?'),
          style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
        ),
        content: Text(
          context.trf('forum_delete_question_message',
              ar: 'هل أنت متأكد أنك تريد حذف هذا السؤال؟',
              en: 'Are you sure you want to delete this question?'),
          style:
          textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              context.trf('cancel', ar: 'إلغاء', en: 'Cancel'),
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.trf('delete', ar: 'حذف', en: 'Delete')),
          ),
        ],
      ),
    );
  }
}
