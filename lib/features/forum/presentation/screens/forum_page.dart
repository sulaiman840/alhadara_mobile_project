// lib/features/forum/presentation/screens/forum_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/const.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/forum_cubit.dart';
import '../../cubit/forum_state.dart';

class ForumPage extends StatelessWidget {
  final int sectionId;

  const ForumPage({Key? key, required this.sectionId}) : super(key: key);

  Future<int> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  void _showNewQuestionDialog(BuildContext ctx) {
    final contentCtl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(        backgroundColor: AppColor.textDarkBlue,

        title: const Text('إنشاء سؤال جديد'),
        content: TextField(
          controller: contentCtl,
          decoration: const InputDecoration(labelText: 'محتوى السؤال'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء',
            style: TextStyle(color: AppColor.white),)),
          ElevatedButton(  style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
            onPressed: () {
              final txt = contentCtl.text.trim();
              if (txt.isNotEmpty) {
                ctx.read<ForumCubit>().addQuestion(sectionId, txt);
                Navigator.pop(ctx);
              }
            },
            child: const Text('نشر',
              style: TextStyle(color: AppColor.white),),
          ),
        ],
      ),
    );
  }

  void _showEditQuestionDialog(BuildContext ctx, int qId, String initial) {
    final ctl = TextEditingController(text: initial);
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.textDarkBlue,
        title: const Text('تعديل السؤال'),
        content: TextField(
          controller: ctl,
          decoration: const InputDecoration(labelText: 'المحتوى'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: AppColor.white),
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            onPressed: () {
              final txt = ctl.text.trim();
              if (txt.isNotEmpty) {
                ctx.read<ForumCubit>().updateQuestion(sectionId, qId, txt);
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'حفظ',
              style: TextStyle(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteQuestion(BuildContext ctx, int qId) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.textDarkBlue,
        title: const Text('حذف السؤال؟'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا السؤال؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: AppColor.white),
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ctx.read<ForumCubit>().removeQuestion(sectionId, qId);
              Navigator.pop(ctx);
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _loadCurrentUserId(),
      builder: (context, userSnap) {
        if (userSnap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final meId = userSnap.data!;
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
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: BlocBuilder<ForumCubit, ForumState>(
              builder: (ctx, state) {
                if (state is ForumLoading)
                  return const Center(child: CircularProgressIndicator());
                if (state is ForumError)
                  return Center(child: Text(state.message));

                final qs = (state as ForumLoaded).questions;
                if (qs.isEmpty)
                  return const Center(
                      child: Text('لا يوجد أسئلة في هذا القسم'));

                return ListView.separated(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemCount: qs.length,
                  itemBuilder: (_, i) {
                    final q = qs[i];
                    final isMine = q.user.id == meId;
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      elevation: 2,
                      color: AppColor.purple,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  q.content,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16.r,
                                      backgroundImage: NetworkImage(
                                        '${ConstString.baseURl}${q.user.photo}',
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(q.user.name,
                                        style: TextStyle(color: Colors.white)),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.thumb_up,
                                          color: Colors.white),
                                      onPressed: () => ctx
                                          .read<ForumCubit>()
                                          .toggleQuestionLike(sectionId, q.id,
                                              q.likesCount > 0),
                                    ),
                                    Text('${q.likesCount}',
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(width: 24.w),
                                    IconButton(
                                      icon: const Icon(Icons.comment, color: Colors.white),
                                      onPressed: () {
                                        context.pushNamed(
                                          'forumDetail',
                                          pathParameters: {
                                            'sectionId': sectionId.toString(),
                                            'questionId': q.id.toString(),
                                          },
                                        );
                                      },
                                    ),                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isMine)
                            Positioned(
                              top: 8.h,
                              left: 8.w,
                              child: PopupMenuButton<String>(
                                color: AppColor.white,
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.white),
                                onSelected: (v) {
                                  if (v == 'edit')
                                    _showEditQuestionDialog(
                                        ctx, q.id, q.content);
                                  else if (v == 'delete')
                                    _confirmDeleteQuestion(ctx, q.id);
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text(
                                      'تعديل',
                                      style: TextStyle(
                                          color: AppColor.textDarkBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(
                                      'حذف',
                                      style: TextStyle(
                                          color: AppColor.textDarkBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
