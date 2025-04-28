import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

import 'forum_page.dart';

class ForumDetailPage extends StatefulWidget {
  final Post post;

  const ForumDetailPage(this.post, {Key? key}) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final _commentController = TextEditingController();

  void _addComment([Comment? parent]) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      final newComment = Comment(
        authorName: 'أنت',
        authorAvatar: 'assets/images/man.png',
        text: text,
      );
      if (parent == null) {
        widget.post.comments.add(newComment);
      } else {
        parent.replies.add(newComment);
      }
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'تفاصيل السؤال',
          onBack: () => Navigator.pop(context),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                children: [
                  // the original question
                  Card(
                    color: AppColor.purple,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.title,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.h),
                          Text(post.content, style: TextStyle(fontSize: 14.sp)),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16.r,
                                backgroundImage: AssetImage(post.authorAvatar),
                              ),
                              SizedBox(width: 8.w),
                              Text(post.authorName),
                              Spacer(),
                              Text(
                                '${post.time.hour}:${post.time.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(color: AppColor.gray3),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // comments & replies
                  ...post.comments.map((c) => _buildCommentTile(c)).toList(),
                ],
              ),
            ),

            // input to add a comment
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              color: AppColor.background,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(style: TextStyle(color: AppColor.textDarkBlue,),
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'أضف تعليقًا...',
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
                    onPressed: () => _addComment(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTile(Comment comment, {int indent = 0}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.w + indent * 16.w,
        right: 24.w,
        bottom: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                // backgroundImage: AssetImage(comment.authorAvatar),
                backgroundImage: AssetImage('assets/images/girl.png'),

              ),
              SizedBox(width: 8.w),
              Text(comment.authorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDarkBlue,
                  )),
              Spacer(),
              IconButton(
                icon: FaIcon(
                  comment.liked
                      ? FontAwesomeIcons.solidThumbsUp
                      : FontAwesomeIcons.thumbsUp,
                  size: 16.r,
                  color: comment.liked ? AppColor.green : AppColor.gray3,
                ),
                onPressed: () => setState(() => comment.liked = !comment.liked),
              ),
              IconButton(
                icon: Icon(
                  Icons.reply,
                  size: 16.r,
                  color: AppColor.textDarkBlue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      final _replyCtl = TextEditingController();
                      return AlertDialog(backgroundColor:  AppColor.purple,
                        title: Text('رد على ${comment.authorName}'),
                        content: TextField(
                          controller: _replyCtl,
                          decoration: InputDecoration(hintText: 'اكتب ردك هنا'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('إلغاء',style: TextStyle(color:  AppColor.white,),)),
                          ElevatedButton(
                            onPressed: () {
                              final text = _replyCtl.text.trim();
                              if (text.isNotEmpty) {
                                setState(() => comment.replies.add(
                                      Comment(
                                        authorName: 'أنت',
                                        authorAvatar: 'assets/images/man.png',
                                        text: text,
                                      ),
                                    ));
                                Navigator.pop(context);
                              }
                            },
                            child: Text('نشر',style: TextStyle(color:  AppColor.white,),),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(comment.text,style: TextStyle(color: AppColor.textDarkBlue,),),
          // show replies
          ...comment.replies
              .map((r) => _buildCommentTile(r, indent: indent + 1))
              .toList(),
        ],
      ),
    );
  }
}
