
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../cubit/quiz_cubit.dart';
import '../../../cubit/quiz_state.dart';

class TestsTab extends StatefulWidget {
  final int sectionId;
  const TestsTab({Key? key, required this.sectionId}) : super(key: key);

  @override
  _TestsTabState createState() => _TestsTabState();
}

class _TestsTabState extends State<TestsTab> {
  final Map<int, int?> _selected = {};
  final Map<int, bool> _confirmed = {};

  @override
  void initState() {
    super.initState();
    context.read<QuizCubit>().fetchQuizzes(widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<QuizCubit, QuizState>(
      listener: (ctx, state) {
        if (state is QuizAnswerResult) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  state.result.isCorrect
                      ? loc.tr('correct')
                      : loc.tr('wrong')
              ),
            ),
          );
        }
      },
      builder: (ctx, state) {
        if (state is QuizLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is QuizError) {
          return Center(child: Text(state.message));
        }
        if (state is QuizLoaded) {
          final quizzes = state.quizzes;
          // ensure maps have entries
          for (var quiz in quizzes) {
            for (var q in quiz.questions) {
              _selected.putIfAbsent(q.id, () => null);
              _confirmed.putIfAbsent(q.id, () => false);
            }
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            itemCount: quizzes.length,
            itemBuilder: (_, quizIdx) {
              final quiz = quizzes[quizIdx];
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 24.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ExpansionTile(
                  backgroundColor: AppColor.purple,
                  collapsedBackgroundColor: AppColor.purple,
                  title: Text(
                    quiz.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: quiz.questions.map((q) {
                    final sel = _selected[q.id];
                    final conf = _confirmed[q.id]!;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 8.h),
                      child: Card(
                        color: AppColor.purple2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.question,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onBackground,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // Options
                              ...q.options.map((opt) {
                                Color bg = theme.colorScheme.surface;
                                if (conf) {
                                  if (opt.isCorrect) {
                                    bg = AppColor.green;
                                  } else if (sel == opt.id) {
                                    bg = AppColor.red;
                                  }
                                }
                                return Card(
                                  color: bg,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  child: RadioListTile<int>(
                                    value: opt.id,
                                    groupValue: sel,
                                    onChanged: conf
                                        ? null
                                        : (v) => setState(() {
                                      _selected[q.id] = v;
                                    }),
                                    title: Text(
                                      opt.optionText,
                                      style: TextStyle(
                                        color: theme.colorScheme.onBackground,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),

                              SizedBox(height: 8.h),

                              // Confirm & Retry buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: !conf && sel != null
                                          ? () => setState(() {
                                        _confirmed[q.id] = true;
                                      })
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        theme.colorScheme.onBackground,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(24.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        loc.tr('confirm_label'),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: conf
                                          ? () => setState(() {
                                        _selected[q.id] = null;
                                        _confirmed[q.id] = false;
                                      })
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        theme.colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(24.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        loc.tr('retry_label'),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
