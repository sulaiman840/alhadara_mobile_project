import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/injection.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/pdf_viewer_page.dart';
import '../../../ratings/cubit/ratings_cubit.dart';
import '../../../ratings/presentation/widgets/section_rating_widget.dart';
import '../../cubit/quiz_cubit.dart';
import '../../cubit/quiz_state.dart';
import '../../cubit/section_files_cubit.dart';
import '../../cubit/section_files_state.dart';
import '../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../../my_course_details/cubit/my_courses_state.dart';

class MyCourseDetailsPage extends StatefulWidget {
  final int enrolledId;

  const MyCourseDetailsPage({
    Key? key,
    required this.enrolledId,
  }) : super(key: key);

  @override
  _MyCourseDetailsPageState createState() => _MyCourseDetailsPageState();
}

class _MyCourseDetailsPageState extends State<MyCourseDetailsPage> {
  bool _tabsPinned = false;

  @override
  void initState() {
    super.initState();
    // ensure courses are loaded
    final cubit = context.read<MyCoursesCubit>();
    if (cubit.state is! MyCoursesSuccess) {
      cubit.fetchMyCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    // heights for scroll logic
    const bannerHeight = 300.0, forumBtnH = 48.0;
    final bannerPx = bannerHeight.h, forumPx = forumBtnH.h;
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: NotificationListener<ScrollNotification>(
          onNotification: (sn) {
            if (sn.depth != 0) return false;
            final shouldPin = sn.metrics.pixels >= pinThreshold;
            if (shouldPin != _tabsPinned)
              setState(() => _tabsPinned = shouldPin);
            return false;
          },
          child: BlocBuilder<MyCoursesCubit, MyCoursesState>(
            builder: (ctx, state) {
              return Scaffold(
                backgroundColor: AppColor.background,
                appBar: CustomAppBar(
                  title: _deriveTitle(state),
                ),
                body: _buildBody(state, bannerPx, forumPx),
              );
            },
          ),
        ),
      ),
    );
  }

  String _deriveTitle(MyCoursesState state) {
    if (state is MyCoursesSuccess) {
      final enrolled = state.courses.firstWhere(
        (e) => e.id == widget.enrolledId,
        orElse: () => throw Exception('Course ${widget.enrolledId} not found'),
      );
      return enrolled.course.name.isNotEmpty
          ? enrolled.course.name
          : 'تفاصيل الكورس';
    }
    return 'تفاصيل الكورس';
  }

  Widget _buildBody(MyCoursesState state, double bannerPx, double forumPx) {
    if (state is MyCoursesLoading || state is MyCoursesInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is MyCoursesFailure) {
      return Center(child: Text(state.errorMessage));
    }

    // success
    final success = state as MyCoursesSuccess;
    final enrolled = success.courses.firstWhere(
      (e) => e.id == widget.enrolledId,
      orElse: () => throw Exception('Course ${widget.enrolledId} not found'),
    );
    final course = enrolled.course;

    // format dates
    final start = enrolled.startDate, end = enrolled.endDate;
    final dateRange = '${start.day}/${start.month}/${start.year} - '
        '${end.day}/${end.month}/${end.year}';
    final created = course.createdAt;
    final activeSince = '${created.day}/${created.month}/${created.year}';

    final bannerUrl = course.photo.isNotEmpty
        ? '${ConstString.baseURl}${course.photo}'
        : null;

    return CustomScrollView(
      slivers: [
        // ── Banner ─────────────────
        SliverToBoxAdapter(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: bannerUrl != null
                ? Image.network(
                    bannerUrl,
                    width: double.infinity,
                    height: bannerPx,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderBanner(bannerPx),
                  )
                : _placeholderBanner(bannerPx),
          ),
        ),

        // ── Forum Button ───────────
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        SliverToBoxAdapter(
          child: Center(
            child: SizedBox(
              width: 250.w,
              height: forumPx,
              child: OutlinedButton(
                onPressed: () {
                  context.pushNamed(
                    'forum',
                    pathParameters: {
                      'sectionId': enrolled.id.toString(),
                    },
                  );
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

        // ── Meta Info ──────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrolled.name,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'نشط منذ $activeSince',
                        style: TextStyle(color: Colors.green, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
                BlocProvider<RatingsCubit>(
                  create: (_) =>
                      getIt<RatingsCubit>()..loadSectionRatings(enrolled.id),
                  child: SectionRatingWidget(sectionId: enrolled.id),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),

        // ── Tabs ─────────────────────
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

        // ── Tab Bodies ───────────────

// ── Tab Bodies ───────────────
        SliverOpacity(
          opacity: _tabsPinned ? 1.0 : 0.5,
          sliver: SliverFillRemaining(
            child: TabBarView(
              children: [
                CourseInfoTab(
                  description: course.description,
                  sectionId: enrolled.id,
                ),
                BlocProvider<SectionFilesCubit>(
                  create: (_) =>
                      getIt<SectionFilesCubit>()..fetchFiles(enrolled.id),
                  child: HomeworkTab(sectionId: enrolled.id),
                ),
                BlocProvider<QuizCubit>(
                  create: (_) => getIt<QuizCubit>()..fetchQuizzes(enrolled.id),
                  child: TestsTab(sectionId: enrolled.id),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _placeholderBanner(double height) => Container(
        width: double.infinity,
        height: height,
        color: Colors.grey[200],
        child: Icon(Icons.broken_image, size: 40.r, color: AppColor.gray3),
      );
}

/// Tab 1: course information
class CourseInfoTab extends StatelessWidget {
  final String description;
  final int sectionId;

  const CourseInfoTab(
      {Key? key, required this.description, required this.sectionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'وصف الكورس',
          //   style: TextStyle(
          //     fontSize: 18.sp,
          //     fontWeight: FontWeight.bold,
          //     color: AppColor.textDarkBlue,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          Text(
            description.isNotEmpty
                ? description
                : 'لا توجد معلومات إضافية حول هذا الكورس حالياً.',
            style: TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue),
          ),
          SizedBox(height: 24.h),

          // SizedBox(height: 16.h),
          // Text(
          //   'أهداف الكورس',
          //   style: TextStyle(
          //     fontSize: 18.sp,
          //     fontWeight: FontWeight.bold,
          //     color: AppColor.textDarkBlue,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          // _bullet('فهم بنية مشروع Flutter'),
          // _bullet('إنشاء واجهات مستخدم مرنة'),
          // _bullet('التنقل بين الصفحات'),
          // _bullet('إدارة الحالة'),
          // SizedBox(height: 16.h),
          // Text(
          //   'المتطلبات',
          //   style: TextStyle(
          //     fontSize: 18.sp,
          //     fontWeight: FontWeight.bold,
          //     color: AppColor.textDarkBlue,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          // _bullet('معرفة أساسية بلغة Dart'),
          // _bullet('بيئة تطوير Flutter'),
        ],
      ),
    );
  }

  Widget _bullet(String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•  ', style: TextStyle(fontSize: 14.sp, height: 1.4)),
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.textDarkBlue,
                      height: 1.4)),
            ),
          ],
        ),
      );
}

/// Tab 2: homework assignments as a PDF list

// …

class HomeworkTab extends StatelessWidget {
  final int sectionId;

  const HomeworkTab({Key? key, required this.sectionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionFilesCubit, SectionFilesState>(
      builder: (ctx, state) {
        if (state is SectionFilesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SectionFilesError) {
          return Center(child: Text(state.message));
        }
        final files = (state as SectionFilesLoaded).files;
        if (files.isEmpty) {
          return const Center(child: Text('لا يوجد واجبات حالياً'));
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          itemCount: files.length,
          separatorBuilder: (_, __) =>
              Divider(color: AppColor.gray3.withOpacity(0.3)),
          itemBuilder: (_, i) {
            final f = files[i];
            final url = '${ConstString.baseURl}${f.filePath}';

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: FaIcon(
                FontAwesomeIcons.solidFilePdf,
                size: 28.r,
                color: Colors.redAccent,
              ),
              title: Text(
                f.fileName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textDarkBlue,
                ),
              ),
              subtitle: Text(
                'تاريخ الإنشاء: ${f.createdAt.day}/${f.createdAt.month}/${f.createdAt.year}',
                style: TextStyle(fontSize: 12.sp, color: AppColor.gray3),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded),
                tooltip: 'تنزيل الـ PDF',
                onPressed: () async {
                  // request storage permission
                  final status = await Permission.storage.request();
                  if (!status.isGranted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('لم يتم منح إذن الكتابة')),
                    );
                    return;
                  }

                  final baseDir = await getExternalStorageDirectory();
                  final downloadsDir = Directory('${baseDir!.path}/Download');
                  if (!downloadsDir.existsSync()) {
                    await downloadsDir.create(recursive: true);
                  }

                  final taskId = await FlutterDownloader.enqueue(
                    url: url,
                    savedDir: downloadsDir.path,
                    fileName: f.fileName,
                    showNotification: true,
                    openFileFromNotification: true,
                  );

                  if (taskId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تعذّر بدء التنزيل')),
                    );
                  }
                },
              ),
              onTap: () => _openPdf(context, url),
            );
          },
        );
      },
    );
  }

  void _openPdf(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PdfViewerPage(url: url)),
    );
  }
}

/// Tab 3: الاختبارات

class TestsTab extends StatefulWidget {
  final int sectionId;

  const TestsTab({Key? key, required this.sectionId}) : super(key: key);

  @override
  _TestsTabState createState() => _TestsTabState();
}

class _TestsTabState extends State<TestsTab> {
  /// Tracks each question's selected option
  final Map<int, int?> _selected = {};

  /// Tracks each question's confirmed state
  final Map<int, bool> _confirmed = {};

  @override
  void initState() {
    super.initState();
    context.read<QuizCubit>().fetchQuizzes(widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizCubit, QuizState>(
      listener: (ctx, state) {
        if (state is QuizAnswerResult) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.result.isCorrect ? '✅ صحيح!' : '❌ خطأ!'),
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

          // Ensure every question has an entry in our maps
          for (var quiz in quizzes) {
            for (var q in quiz.questions) {
              _selected.putIfAbsent(q.id, () => null);
              _confirmed.putIfAbsent(q.id, () => false);
            }
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            itemCount: quizzes.length,
            itemBuilder: (context, quizIdx) {
              final quiz = quizzes[quizIdx];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.only(bottom: 24.h),
                elevation: 4,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                                  color: AppColor.textDarkBlue,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // Options
                              ...q.options.map((opt) {
                                Color bg = AppColor.white;
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
                                    title: Text(opt.optionText,
                                        style: TextStyle(
                                            color: AppColor.textDarkBlue,
                                            fontSize: 14.sp)),
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
                                          ? () => setState(
                                              () => _confirmed[q.id] = true)
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.textDarkBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        'تأكيد',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                        backgroundColor: AppColor.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        'إعادة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
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
          unselectedLabelColor: AppColor.gray3,
          dividerColor: AppColor.background,
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          tabs: _tabs,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.pinned != pinned || old._tabs != _tabs;
}
