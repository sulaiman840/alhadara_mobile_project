import 'package:alhadara_mobile_project/features/forum/presentation/widgets/forum_page_widgets/question_menu.dart';
import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/const.dart';
import '../../../cubit/forum_cubit.dart';

class QuestionCard extends StatelessWidget {
  final int sectionId;
  final dynamic question;
  final bool isMine;

  const QuestionCard({
    super.key,
    required this.sectionId,
    required this.question,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.content,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundImage:
                      NetworkImage('${ConstString.baseURl}${question.user.photo}'),
                      backgroundColor: scheme.primary.withValues(alpha: 0.1),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      question.user.name,
                      style:
                      textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: scheme.primary),
                      onPressed: () => context.read<ForumCubit>().toggleQuestionLike(
                        sectionId,
                        question.id,
                        question.likesCount > 0,
                      ),
                      tooltip: context.trf('like', ar: 'إعجاب', en: 'Like'),
                    ),
                    Text(
                      '${question.likesCount}',
                      style:
                      textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
                    ),
                    SizedBox(width: 24.w),
                    IconButton(
                      icon: Icon(Icons.comment, color: scheme.primary),
                      onPressed: () {
                        context.pushNamed(
                          'forumDetail',
                          pathParameters: {
                            'sectionId': sectionId.toString(),
                            'questionId': question.id.toString(),
                          },
                        );
                      },
                      tooltip: context.trf('comments_title',
                          ar: 'التعليقات', en: 'Comments'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isMine)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: QuestionMenu(
                sectionId: sectionId,
                questionId: question.id,
                initialText: question.content,
              ),
            ),
        ],
      ),
    );
  }
}
