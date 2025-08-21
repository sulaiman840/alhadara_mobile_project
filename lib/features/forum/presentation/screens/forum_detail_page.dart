import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/forum_cubit.dart';
import '../../cubit/forum_state.dart';
import '../widgets/forum_detail_page_widgets/answer_composer.dart';
import '../widgets/forum_detail_page_widgets/answer_tile.dart';
import '../widgets/forum_detail_page_widgets/empty_answers.dart';
import '../widgets/forum_detail_page_widgets/error_text.dart';
import '../widgets/forum_detail_page_widgets/question_header_card.dart';

class ForumDetailPage extends StatefulWidget {
  final int sectionId;
  final int questionId;

  const ForumDetailPage({
    Key? key,
    required this.sectionId,
    required this.questionId,
  }) : super(key: key);

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  late Future<int> _meIdFuture;

  @override
  void initState() {
    super.initState();
    _meIdFuture = _loadCurrentUserId();
  }

  Future<int> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.dir,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: context.trf(
            'question_details_title',
            ar: 'تفاصيل السؤال',
            en: 'Question details',
          ),
        ),
        body: FutureBuilder<int>(
          future: _meIdFuture,
          builder: (ctx, userSnap) {
            if (userSnap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final meId = userSnap.data ?? 0;

            return BlocBuilder<ForumCubit, ForumState>(
              builder: (ctx, state) {
                if (state is ForumLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ForumError) {
                  return ErrorText(message: state.message);
                }
                final loaded = state as ForumLoaded;
                final question = loaded.questions
                    .firstWhere((q) => q.id == widget.questionId);

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        children: [
                          QuestionHeaderCard(question: question),
                          SizedBox(height: 24.h),
                          if (question.answers.isEmpty)
                            EmptyAnswers()
                          else
                            ...question.answers.map(
                                  (a) => AnswerTile(
                                sectionId: widget.sectionId,
                                answer: a,
                                isMine: a.user.id == meId,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnswerComposer(
                      hintText: context.trf(
                        'answer_hint',
                        ar: 'أضف إجابة...',
                        en: 'Add an answer...',
                      ),
                      onSubmit: (txt) {
                        if (txt.trim().isEmpty) return;
                        context.read<ForumCubit>().addAnswer(
                          widget.sectionId,
                          widget.questionId,
                          txt.trim(),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}










