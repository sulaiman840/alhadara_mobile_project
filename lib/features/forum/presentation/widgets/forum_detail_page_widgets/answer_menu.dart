import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/forum_cubit.dart';
import 'confirm_delete_answer_dialog.dart';
import 'edit_answer_dialog.dart';

class AnswerMenu extends StatelessWidget {
  final int sectionId;
  final dynamic answer;

  const AnswerMenu({super.key, required this.sectionId, required this.answer});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopupMenuButton<String>(
      color: Theme.of(context).cardColor,
      icon: Icon(Icons.more_vert, color: scheme.onSurface.withOpacity(0.9)),
      onSelected: (v) async {
        if (v == 'edit') {
          final updated = await showDialog<String>(
            context: context,
            builder: (_) => EditAnswerDialog(initialText: answer.content),
          );
          final val = updated?.trim();
          if (val != null && val.isNotEmpty && context.mounted) {
            context.read<ForumCubit>().updateAnswer(sectionId, answer.id, val);
          }
        } else if (v == 'delete') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => const ConfirmDeleteAnswerDialog(),
          );
          if (confirm == true && context.mounted) {
            context.read<ForumCubit>().removeAnswer(sectionId, answer.id);
          }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Text(
            context.trf('edit', ar: 'تعديل', en: 'Edit'),
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            context.trf('delete', ar: 'حذف', en: 'Delete'),
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
