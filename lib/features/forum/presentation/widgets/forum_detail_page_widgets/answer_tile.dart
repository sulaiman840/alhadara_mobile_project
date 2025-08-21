import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/const.dart';
import '../../../cubit/forum_cubit.dart';
import 'answer_menu.dart';

class AnswerTile extends StatelessWidget {
  final int sectionId;
  final dynamic answer;
  final bool isMine;

  const AnswerTile({
    super.key,
    required this.sectionId,
    required this.answer,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: cardColor,
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.15)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundImage: NetworkImage('${ConstString.baseURl}${answer.user.photo}'),
          backgroundColor: scheme.primary.withOpacity(0.1),
        ),
        title: Text(
          answer.content,
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
        ),
        subtitle: Text(
          answer.user.name,
          style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.7)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: context.trf('like', ar: 'إعجاب', en: 'Like'),
              icon: Icon(
                Icons.thumb_up,
                color: answer.likesCount > 0
                    ? scheme.primary
                    : scheme.onSurface.withOpacity(0.35),
              ),
              onPressed: () => context.read<ForumCubit>().toggleAnswerLike(
                sectionId,
                answer.id,
                answer.likesCount > 0,
              ),
            ),
            if (isMine) AnswerMenu(sectionId: sectionId, answer: answer),
          ],
        ),
      ),
    );
  }
}