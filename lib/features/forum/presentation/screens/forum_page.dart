// lib/features/forum/ui/forum_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// Simple data models
class Comment {
  final String authorName;
  final String authorAvatar;
  final String text;
  bool liked;
  final List<Comment> replies;

  Comment({
    required this.authorName,
    required this.authorAvatar,
    required this.text,
    this.liked = false,
    this.replies = const [],
  });
}

class Post {
  final String title;
  final String content;
  final String authorName;
  final String authorAvatar;
  final DateTime time;
  bool liked;
  final List<Comment> comments;

  Post({
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorAvatar,
    required this.time,
    this.liked = false,
    this.comments = const [],
  });
}

/// The main forum screen.
class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final List<Post> _posts = [
    Post(
      title: 'ما الفرق بين StatelessWidget و StatefulWidget؟',
      content: 'أنا مبتدئ في Flutter وأريد أن أفهم الفرق بين StatelessWidget و StatefulWidget',
      authorName: 'أحمد السعيد',
      authorAvatar: 'assets/images/man.png',
      time: DateTime.now(),
      comments: [
        Comment(
          authorName: 'ليلى محمد',
          authorAvatar: 'assets/images/woman.png',
          text: 'StatelessWidget لا يحتفظ بأي حالة (state) ويمكن إعادة بنائه بسهولة، بينما StatefulWidget يحتفظ بحالة داخلية يمكن تغييرها عبر setState().',
        ),
      ],
    ),
    Post(
      title: 'ما الفرق بين StatelessWidget و StatefulWidget؟',
      content: 'أنا مبتدئ في Flutter وأريد أن أفهم الفرق بين StatelessWidget و StatefulWidget',
      authorName: 'أحمد السعيد',
      authorAvatar: 'assets/images/man.png',
      time: DateTime.now(),
      comments: [
        Comment(
          authorName: 'ليلى محمد',
          authorAvatar: 'assets/images/woman.png',
          text: 'StatelessWidget لا يحتفظ بأي حالة (state) ويمكن إعادة بنائه بسهولة، بينما StatefulWidget يحتفظ بحالة داخلية يمكن تغييرها عبر setState().',
        ),
      ],
    ),
  ];

  void _showNewQuestionDialog() {
    final _titleCtl = TextEditingController();
    final _contentCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('إنشاء سؤال جديد', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtl,
              decoration: InputDecoration(
                labelText: 'عنوان السؤال',
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _contentCtl,
              decoration: InputDecoration(
                labelText: 'تفاصيل السؤال',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (_titleCtl.text.trim().isNotEmpty) {
                setState(() {
                  _posts.insert(
                    0,
                    Post(
                      title: _titleCtl.text.trim(),
                      content: _contentCtl.text.trim(),
                      authorName: 'أنت',
                      authorAvatar: 'assets/images/man.png',
                      time: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(context);
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
      child: Scaffold(backgroundColor:AppColor.background,
        appBar: CustomAppBar(
          title: 'المنتدى',
          onBack: () => context.pop(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.purple2,
          onPressed: _showNewQuestionDialog,
          child: Icon(Icons.add, color: Colors.white,size: 30.sp,),
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          itemCount: _posts.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, idx) {
            final post = _posts[idx];
            final isLiked = post.liked;
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              elevation: 2,color: AppColor.purple,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Text(
                      post.title,
                      style: TextStyle(
                        fontSize: 20.sp,color:  AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // content
                    Text(
                      post.content,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.white.withOpacity(0.8)),
                    ),
                    SizedBox(height: 12.h),
                    // author & time
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16.r,
                          backgroundImage: AssetImage(post.authorAvatar),
                        ),
                        SizedBox(width: 8.w),
                        Text(post.authorName,
                            style: TextStyle(fontSize: 12.sp)),
                        Spacer(),
                        Text(
                          '${post.time.hour}:${post.time.minute.toString().padLeft(2, '0')}',
                          style:
                              TextStyle(fontSize: 12.sp, color: AppColor.gray3),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // actions: like & comment
                    Row(
                      children: [
                        IconButton(
                          icon: FaIcon(
                            isLiked
                                ? FontAwesomeIcons.solidThumbsUp
                                : FontAwesomeIcons.thumbsUp ,
                            color: isLiked ? AppColor.green : AppColor.gray3,
                            size: 18.r,
                          ),
                          onPressed: () {
                            setState(() => post.liked = !isLiked);
                          },
                        ),
                        SizedBox(width: 4.w),
                        Text('${post.liked ? 1 : 0}',
                            style: TextStyle(fontSize: 12.sp)),
                        SizedBox(width: 24.w),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.comment,
                              size: 18.r, color: AppColor.gray3),
                          onPressed: () {
                            context.push('/forum/detail', extra: post);
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
