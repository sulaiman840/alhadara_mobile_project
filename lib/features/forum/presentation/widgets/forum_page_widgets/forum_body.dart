import 'package:alhadara_mobile_project/features/forum/presentation/widgets/forum_page_widgets/questions_list.dart';
import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/forum_cubit.dart';
import '../../../cubit/forum_state.dart';

class ForumBody extends StatelessWidget {
  final int sectionId;
  final int meId;

  const ForumBody({required this.sectionId, required this.meId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ForumCubit, ForumState>(
      builder: (ctx, state) {
        if (state is ForumLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ForumError) {
          return Center(
            child: Text(
              // If message is a key in your l10n, you can use context.trf
              state.message,
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
              textAlign: TextAlign.center,
            ),
          );
        }

        final qs = (state as ForumLoaded).questions;
        if (qs.isEmpty) {
          return Center(
            child: Text(
              context.trf('forum_no_questions',
                  ar: 'لا يوجد أسئلة في هذا القسم',
                  en: 'No questions in this section'),
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
          );
        }

        return QuestionsList(
          sectionId: sectionId,
          meId: meId,
          questions: qs,
        );
      },
    );
  }
}
