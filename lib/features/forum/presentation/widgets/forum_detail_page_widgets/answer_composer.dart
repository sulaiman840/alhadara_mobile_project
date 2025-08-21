import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerComposer extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSubmit;

  const AnswerComposer({
    super.key,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  State<AnswerComposer> createState() => _AnswerComposerState();
}

class _AnswerComposerState extends State<AnswerComposer> {
  final _ctl = TextEditingController();

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctl.text.trim();
    if (text.isEmpty) return;
    widget.onSubmit(text);
    _ctl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctl,
                keyboardType: TextInputType.text,
                cursorColor: scheme.primary,
                style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurface.withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: scheme.primary),
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              tooltip: context.trf('send', ar: 'إرسال', en: 'Send'),
              icon: Icon(Icons.send, color: scheme.primary),
              onPressed: _send,
            ),
          ],
        ),
      ),
    );
  }
}
