// lib/features/forum/presentation/screens/forum_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/forum_cubit.dart';
import '../../cubit/forum_state.dart';

class ForumDetailPage extends StatefulWidget {
  final int sectionId;
  final int questionId;

  const ForumDetailPage({
    Key? key,
    required this.sectionId,
    required this.questionId,
  }) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  late Future<int> _meIdFuture;
  final _answerCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _meIdFuture = _loadCurrentUserId();
  }

  Future<int> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  void _showEditAnswerDialog(BuildContext ctx, int aId, String initial) {
    final ctl = TextEditingController(text: initial);
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.textDarkBlue,
        title: const Text('تعديل الإجابة', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctl,
          decoration: const InputDecoration(labelText: 'المحتوى'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: AppColor.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            onPressed: () {
              final txt = ctl.text.trim();
              if (txt.isNotEmpty) {
                ctx.read<ForumCubit>().updateAnswer(widget.sectionId, aId, txt);
                Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ', style: TextStyle(color: AppColor.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAnswer(BuildContext ctx, int aId) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.textDarkBlue,
        title: const Text('حذف الإجابة؟'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذه الإجابة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: AppColor.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ctx.read<ForumCubit>().removeAnswer(widget.sectionId, aId);
              Navigator.pop(ctx);
            },
            child: const Text('حذف', style: TextStyle(color: AppColor.white)),
          ),
        ],
      ),
    );
  }

  void _submitAnswer() {
    final txt = _answerCtl.text.trim();
    if (txt.isNotEmpty) {
      context
          .read<ForumCubit>()
          .addAnswer(widget.sectionId, widget.questionId, txt);
      _answerCtl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(title: 'تفاصيل السؤال'),
        body: FutureBuilder<int>(
          future: _meIdFuture,
          builder: (ctx, userSnap) {
            if (userSnap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final meId = userSnap.data!;
            return BlocBuilder<ForumCubit, ForumState>(
              builder: (ctx, state) {
                if (state is ForumLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ForumError) {
                  return Center(child: Text(state.message));
                }
                final question = (state as ForumLoaded)
                    .questions
                    .firstWhere((q) => q.id == widget.questionId);

                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  children: [
                    // Question card
                    Card(
                      color: AppColor.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: NetworkImage(
                                    '${ConstString.baseURl}${question.user.photo}',
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  question.user.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              question.content,
                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Answers list
                    ...question.answers.map((a) {
                      final isMine = a.user.id == meId;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Card(
                          color: AppColor.purple,
                          margin: EdgeInsets.zero,
                          elevation: 1,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                '${ConstString.baseURl}${a.user.photo}',
                              ),
                            ),
                            title: Text(a.content,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(a.user.name,
                                style: TextStyle(color: Colors.white70)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up,
                                      color: a.likesCount > 0
                                          ? AppColor.green
                                          : AppColor.gray3),
                                  onPressed: () => ctx
                                      .read<ForumCubit>()
                                      .toggleAnswerLike(widget.sectionId,
                                      a.id, a.likesCount > 0),
                                ),
                                if (isMine)
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert,
                                        size: 20.r, color: Colors.white),
                                    color: AppColor.white,
                                    onSelected: (v) {
                                      if (v == 'edit')
                                        _showEditAnswerDialog(ctx, a.id, a.content);
                                      else if (v == 'delete')
                                        _confirmDeleteAnswer(ctx, a.id);
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('تعديل',
                                            style: TextStyle(
                                                color: AppColor.textDarkBlue,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('حذف',
                                            style: TextStyle(
                                                color: AppColor.textDarkBlue,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            );
          },
        ),

        // bottomSheet lifts above the keyboard automatically
        bottomSheet: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: AppColor.background,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answerCtl,keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: AppColor.textDarkBlue,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'أضف إجابة...',
                      hintStyle: TextStyle(color: AppColor.textDarkBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(Icons.send, color: AppColor.purple),
                  onPressed: _submitAnswer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
