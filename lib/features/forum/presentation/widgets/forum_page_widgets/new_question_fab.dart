import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/forum_cubit.dart';
import 'new_question_dialog.dart';

class NewQuestionFab extends StatelessWidget {
  final int sectionId;
  const NewQuestionFab({required this.sectionId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      onPressed: () async {
        final txt = await showDialog<String>(
          context: context,
          builder: (_) => const NewQuestionDialog(),
        );
        final value = txt?.trim();
        if (value != null && value.isNotEmpty && context.mounted) {
          context.read<ForumCubit>().addQuestion(sectionId, value);
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
