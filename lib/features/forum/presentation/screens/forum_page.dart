import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/forum_cubit.dart';
import '../../cubit/forum_state.dart';

class ForumPage extends StatelessWidget {
  final int sectionId;
  const ForumPage({required this.sectionId, Key? key}) : super(key: key);

  void _showNewQuestionDialog(BuildContext ctx) {
    final titleCtl = TextEditingController();
    final contentCtl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('إنشاء سؤال جديد', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtl, decoration: InputDecoration(labelText: 'عنوان السؤال')),
            SizedBox(height: 12.h),
            TextField(controller: contentCtl, decoration: InputDecoration(labelText: 'تفاصيل السؤال'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (titleCtl.text.trim().isNotEmpty) {
                ctx.read<ForumCubit>().addQuestion(
                  sectionId,
                  titleCtl.text.trim(),
                  contentCtl.text.trim(),
                );
                Navigator.pop(ctx);
              }
            },
            child: Text('نشر'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'المنتدى',
          onBack: () => context.pop(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.purple2,
          onPressed: () => _showNewQuestionDialog(context),
          child: Icon(Icons.add, color: Colors.white, size: 30.sp),
        ),
        body: BlocBuilder<ForumCubit, ForumState>(
          builder: (ctx, state) {
            if (state is ForumLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ForumError) {
              return Center(child: Text(state.message, style: TextStyle(color: AppColor.textDarkBlue)));
            }
            final questions = (state as ForumLoaded).questions;
            if (questions.isEmpty) {
              return const Center(child: Text('لا يوجد أسئلة في هذا القسم', style: TextStyle(color: AppColor.textDarkBlue)));
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              itemCount: questions.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (_, i) {
                final q = questions[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  elevation: 2,
                  color: AppColor.purple,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(q.title, style: TextStyle(fontSize: 20.sp, color: AppColor.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.h),
                        Text(q.content, style: TextStyle(fontSize: 16.sp, color: AppColor.white.withOpacity(0.8))),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundImage: NetworkImage('${ConstString.baseURl}${q.user.photo}'),
                            ),
                            SizedBox(width: 8.w),
                            Text(q.user.name, style: TextStyle(fontSize: 12.sp, color: AppColor.white)),
                            Spacer(),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.thumbsUp, size: 18.r, color: AppColor.white),
                              onPressed: () => ctx.read<ForumCubit>().toggleQuestionLike(sectionId, q.id),
                            ),
                            Text('${q.likes.length}', style: TextStyle(color: AppColor.white)),
                            SizedBox(width: 24.w),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.comment, size: 18.r, color: AppColor.white),
                              onPressed: () {
                                context.go(
                                  AppRoutesNames.forumDetail
                                      .replaceAll(':sectionId', '$sectionId')
                                      .replaceAll(':questionId', '${q.id}'),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
