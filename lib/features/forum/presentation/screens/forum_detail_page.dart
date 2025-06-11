import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/forum_cubit.dart';
import '../../cubit/forum_state.dart';

class ForumDetailPage extends StatefulWidget {
  final int sectionId;
  final int questionId;
  const ForumDetailPage({
    required this.sectionId,
    required this.questionId,
    Key? key,
  }) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final _answerCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'تفاصيل السؤال',
          onBack: () =>  context.go('/forum/${widget.sectionId}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ForumCubit, ForumState>(
                builder: (ctx, state) {
                  if (state is ForumLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ForumError) {
                    return Center(child: Text(state.message));
                  }
                  final q = (state as ForumLoaded)
                      .questions
                      .firstWhere((q) => q.id == widget.questionId);

                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    children: [
                      // question card
                      Card(
                        color: AppColor.purple,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(q.title, style: TextStyle(fontSize: 18.sp, color: AppColor.white, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8.h),
                              Text(q.content, style: TextStyle(fontSize: 14.sp, color: AppColor.white)),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16.r,
                                    backgroundImage: NetworkImage('${ConstString.baseURl}${q.user.photo}'),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(q.user.name, style: TextStyle(color: AppColor.white)),
                                  Spacer(),
                                  // Text(
                                  //   '${q.createdAt.hour}:${q.createdAt.minute.toString().padLeft(2,'0')}',
                                  //   style: TextStyle(color: AppColor.white),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // answers list
                      ...q.answers.map((a) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Card(color: AppColor.purple,
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('${ConstString.baseURl}${a.user.photo}'),
                            ),
                            title: Text(a.content),
                            subtitle: Text(a.user.name),
                            trailing: IconButton(
                              icon: Icon(Icons.thumb_up, color: a.isAccepted ? AppColor.green : AppColor.gray3),
                              onPressed: () => ctx.read<ForumCubit>().toggleAnswerLike(widget.sectionId, a.id),
                            ),
                          ),
                        ),
                      )),
                    ],
                  );
                },
              ),
            ),

            // input to add an answer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              color: AppColor.background,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _answerCtl,
                      decoration: InputDecoration(
                        hintText: 'أضف إجابة...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.r)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColor.purple),
                    onPressed: () {
                      final text = _answerCtl.text.trim();
                      if (text.isNotEmpty) {
                        context.read<ForumCubit>().addAnswer(
                          widget.sectionId,
                          widget.questionId,
                          text,
                        );
                        _answerCtl.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
