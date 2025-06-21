import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:alhadara_mobile_project/core/utils/app_colors.dart';

import '../../../../shared/widgets/custom_app_bar.dart';

class MyTestDetailsPage extends StatefulWidget {
  const MyTestDetailsPage({Key? key}) : super(key: key);

  @override
  _MyTestDetailsPageState createState() => _MyTestDetailsPageState();
}

class _MyTestDetailsPageState extends State<MyTestDetailsPage> {
  bool _tabsPinned = false;

  @override
  Widget build(BuildContext context) {
    // Design heights (unscaled)
    const bannerHeight = 300.0;
    const forumBtnH = 48.0;

    // Scale them to actual logical pixels
    final bannerPx = bannerHeight.h;
    final forumPx = forumBtnH.h;
    // When scroll offset reaches this, the tabs are “pinned”
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: NotificationListener<ScrollNotification>(
          onNotification: (sn) {
            // only react to the outer CustomScrollView
            if (sn.depth != 0) return false;

            final offset = sn.metrics.pixels;
            final shouldPin = offset >= pinThreshold;
            if (shouldPin != _tabsPinned) {
              setState(() => _tabsPinned = shouldPin);
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColor.background,
            appBar: CustomAppBar(
              title: 'تفاصيل الكورس',
            ),
            body: CustomScrollView(
              slivers: [
                // ── Banner ─────────────────────────────
                SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      'assets/images/Flutter.png',
                      width: double.infinity,
                      height: bannerPx,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // ── Spacer + Forum Button ───────────────────────
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 250.w,
                      height: forumPx,
                      child: OutlinedButton(
                        onPressed: () {


                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColor.purple,
                          side: BorderSide(color: AppColor.purple, width: 2.r),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                        child: Text(
                          'المنتدى',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),

                // ── Title & Meta ───────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كورس تعلم Flutter: للمبتدئين',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'نشط منذ 1/1/2024',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            FaIcon(FontAwesomeIcons.solidStar,
                                color: AppColor.yellow, size: 14.r),
                            SizedBox(width: 4.w),
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.textDarkBlue,
                              ),
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.pen,
                                  color: AppColor.purple, size: 16.r),
                              onPressed: () {
                                // TODO: Navigate to rating screen
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundImage:
                              AssetImage('assets/images/man.png'),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'احمد بلال',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.textDarkBlue,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                // TODO: Trainer profile
                              },
                              style: TextButton.styleFrom(
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap),
                              child: Text(
                                'زيارة بروفايل المدرب',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                // ── Tabs ────────────────────────────────
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    const [
                      Tab(text: 'معلومات الكورس'),
                      Tab(text: 'وظائف'),
                      Tab(text: 'اختبارات'),
                    ],
                    pinned: _tabsPinned,
                  ),
                ),

                // ── Tab Body ─────────────────────────────
                SliverFillRemaining(
                  child: Stack(
                    children: [
                      const TabBarView(
                        children: [
                          CourseInfoTab(),
                          HomeworkTab(),
                          TestsTab(),
                        ],
                      ),
                      // fade the entire content until the tabs are pinned
                      if (!_tabsPinned)
                        Positioned.fill(
                          child: Container(
                            color: AppColor.background.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// Tab 1: course information (now scrollable)
class CourseInfoTab extends StatelessWidget {
  const CourseInfoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وصف الكورس',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.textDarkBlue,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'في هذا الكورس سنتعرف على أساسيات Flutter لتطوير تطبيقات الجوال من الصفر. '
                'سنغطي إعداد البيئة، كتابة الواجهات التفاعلية، وإدارة الحالة البسيطة.',
            style: TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue),
          ),
          SizedBox(height: 16.h),

          Text(
            'أهداف الكورس',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.textDarkBlue,
            ),
          ),
          SizedBox(height: 8.h),
          _buildBullet('فهم بنية مشروع Flutter'),
          _buildBullet('إنشاء واجهات مستخدم مرنة باستخدام Widgets'),
          _buildBullet('التعامل مع التنقل بين الصفحات'),
          _buildBullet('إدارة الحالة باستخدام setState'),
          SizedBox(height: 16.h),

          Text(
            'المتطلبات',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.textDarkBlue,
            ),
          ),
          SizedBox(height: 8.h),
          _buildBullet('معرفة أساسية بلغة Dart أو لغة برمجة أخرى'),
          _buildBullet('بيئة تطوير Flutter مثبتة'),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: TextStyle(fontSize: 14.sp, height: 1.4)),
          Expanded(
            child: Text(
              text,
              style:
              TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab 2: homework assignments as a PDF list
class HomeworkTab extends StatelessWidget {
  const HomeworkTab({Key? key}) : super(key: key);

  // Fake data for a beginner Flutter course
  final List<Map<String, String>> _homeworks = const [
    {
      'title': 'واجب 1: تثبيت Flutter وإعداد البيئة',
      'file': 'assets/homeworks/assignment1.pdf',
      'date': '2025-04-01',
    },
    {
      'title': 'واجب 2: إنشاء أول Widget',
      'file': 'assets/homeworks/assignment2.pdf',
      'date': '2025-04-08',
    },
    {
      'title': 'واجب 3: التنقل بين الصفحات',
      'file': 'assets/homeworks/assignment3.pdf',
      'date': '2025-04-15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      itemCount: _homeworks.length,
      separatorBuilder: (_, __) => Divider(color: AppColor.gray3.withValues( alpha: 0.3)),
      itemBuilder: (context, i) {
        final hw = _homeworks[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: FaIcon(
            FontAwesomeIcons.solidFilePdf,
            size: 28.r,
            color: Colors.redAccent,
          ),
          title: Text(
            hw['title']!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.textDarkBlue,
            ),
          ),
          subtitle: Text(
            'تاريخ التسليم: ${hw['date']}',
            style: TextStyle(fontSize: 12.sp, color: AppColor.gray3),
          ),
          trailing: IconButton(
            icon: FaIcon(FontAwesomeIcons.download, size: 20.r),
            onPressed: () {
              // TODO: open or download hw['file']
            },
          ),
          onTap: () {
            // TODO: preview the PDF in‐app
          },
        );
      },
    );
  }
}


/// Tab 3: الاختبارات
class TestsTab extends StatefulWidget {
  const TestsTab({Key? key}) : super(key: key);
  @override
  _TestsTabState createState() => _TestsTabState();
}

class _TestsTabState extends State<TestsTab> {
  final List<Map<String, dynamic>> _tests = [
    {
      'title': 'اختبار الوحدة الأولى',
      'questions': [
        {
          'text': 'ما هي لغة برمجة Flutter؟',
          'options': [
            'لغة لإنشاء تطبيقات الويب',
            'إطار عمل لتطوير واجهات المستخدم',
            'قاعدة بيانات NoSQL',
            'محرك لعبة ثلاثية الأبعاد',
          ],
        },
        {
          'text': 'أي ويدجت يستخدم لإظهار نص ثابت؟',
          'options': ['Text', 'Column', 'Row', 'Container'],
        },
      ],
    },
    {
      'title': 'اختبار الوحدة الثانية',
      'questions': [
        {
          'text': 'كيف نغيّر الحالة داخل StatefulWidget؟',
          'options': [
            'باستخدام Provider',
            'من خلال setState',
            'باستخدام Bloc',
            'لا يمكن تغييرها',
          ],
        },
        {
          'text': 'أي من هذه ليست خاصية لـ Container؟',
          'options': ['padding', 'margin', 'color', 'onPressed'],
        },
      ],
    },
  ];

  late List<List<int?>> _selectedAnswers;
  late List<bool> _expanded;
  late List<bool> _confirmed;

  @override
  void initState() {
    super.initState();
    _expanded = List<bool>.filled(_tests.length, false);
    _confirmed = List<bool>.filled(_tests.length, false);
    _selectedAnswers = _tests
        .map((t) => List<int?>.filled((t['questions'] as List).length, null))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: _tests.length,
      itemBuilder: (context, testIdx) {
        final test = _tests[testIdx];
        return Card(
          elevation: 2,color: AppColor.purple,
          margin: EdgeInsets.only(bottom: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          child: ExpansionTile(
            key: Key('test_$testIdx'),
            title: Text(
              test['title'] as String,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.white,
              ),
            ),
            initiallyExpanded: _expanded[testIdx],
            onExpansionChanged: (open) {
              setState(() => _expanded[testIdx] = open);
            },
            children: [
              ...List.generate((test['questions'] as List).length, (qIdx) {
                final q = (test['questions'] as List)[qIdx] as Map<String, dynamic>;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'السؤال ${qIdx + 1}: ${q['text']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color:AppColor.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ...List.generate((q['options'] as List).length, (optIdx) {
                        final option = (q['options'] as List)[optIdx] as String;
                        return RadioListTile<int>(
                          contentPadding: EdgeInsets.zero,
                          value: optIdx,
                          groupValue: _selectedAnswers[testIdx][qIdx],
                          onChanged: _confirmed[testIdx]
                              ? null
                              : (v) => setState(() {
                            _selectedAnswers[testIdx][qIdx] = v;
                          }),
                          title: Text(
                            option,
                            style: TextStyle(fontSize: 14.sp, color: AppColor.white,),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmed[testIdx]
                        ? null
                        : () {
                      final answers = _selectedAnswers[testIdx];
                      if (answers.any((a) => a == null)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('من فضلك اختر إجابة لكل سؤال.')),
                        );
                        return;
                      }
                      setState(() => _confirmed[testIdx] = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم تأكيد إجاباتك.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      _confirmed[testIdx] ? 'تم التأكيد' : 'تأكيد الإجابات',
                      style: TextStyle(color:AppColor.textDarkBlue, fontSize: 14.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }
}



/// Small project card
class ProjectCard extends StatelessWidget {
  final String imagePath;
  const ProjectCard(this.imagePath, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.asset(imagePath, height: 140.h, fit: BoxFit.cover),
    );
  }
}

/// Fades the TabBar until it’s scrolled into its pinned position
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final List<Tab> _tabs;
  final bool pinned;
  _TabBarDelegate(this._tabs, {required this.pinned});

  @override
  double get minExtent => _tabs.first.preferredSize.height;
  @override
  double get maxExtent => _tabs.first.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Opacity(
      opacity: pinned ? 1.0 : 0.5,
      child: Material(
        color: AppColor.background,
        elevation: overlapsContent ? 4 : 0,
        child: TabBar(
          indicatorColor: AppColor.purple,
          labelColor: AppColor.purple,
          unselectedLabelColor: AppColor.gray3,dividerColor:AppColor.background,
          labelStyle:
          TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          tabs: _tabs,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.pinned != pinned || old._tabs != _tabs;
}
