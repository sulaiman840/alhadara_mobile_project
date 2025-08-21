import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditAnswerDialog extends StatefulWidget {
  final String initialText;
  const EditAnswerDialog({super.key, required this.initialText});

  @override
  State<EditAnswerDialog> createState() => _EditAnswerDialogState();
}

class _EditAnswerDialogState extends State<EditAnswerDialog> {
  late final TextEditingController _ctl =
  TextEditingController(text: widget.initialText);

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
          context.trf('edit_answer_title', ar: 'تعديل الإجابة', en: 'Edit answer'),
          style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
        ),
        content: TextField(
          controller: _ctl,
          maxLines: 3,
          cursorColor: scheme.primary,
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            labelText: context.trf('content', ar: 'المحتوى', en: 'Content'),
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
              context.trf('save', ar: 'حفظ', en: 'Save'),
              style: textTheme.bodyMedium?.copyWith(color: scheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
