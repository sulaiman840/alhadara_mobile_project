import 'package:alhadara_mobile_project/features/forum/presentation/widgets/forum_page_widgets/question_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionsList extends StatelessWidget {
  final int sectionId;
  final int meId;
  final List<dynamic> questions;

  const QuestionsList({
    required this.sectionId,
    required this.meId,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemCount: questions.length,
      itemBuilder: (_, i) {
        final q = questions[i];
        final isMine = (q.user.id == meId);
        return QuestionCard(
          sectionId: sectionId,
          question: q,
          isMine: isMine,
        );
      },
    );
  }
}
