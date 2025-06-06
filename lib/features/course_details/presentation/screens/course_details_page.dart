import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../home/data/models/course_model.dart';

class CourseDetailsPage extends StatefulWidget {
  final CourseModel course;
  final String deptName;

  const CourseDetailsPage({
    Key? key,
    required this.course,
    required this.deptName,
  }) : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  bool _tabsPinned = false;

  @override
  Widget build(BuildContext context) {
    // Design heights (unscaled)
    const bannerHeight = 300.0;
    const forumBtnH = 48.0;

    final bannerPx = bannerHeight.h;
    final forumPx = forumBtnH.h;
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;

    // Format “active since” from course.createdAt
    final created = widget.course.createdAt;
    final activeSince = '${created.day}/${created.month}/${created.year}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (sn) {
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
              onBack: () {
                // We know: widget.course.departmentId  and  widget.deptName
                context.go(
                  AppRoutesNames.coursesList,
                  extra: {
                    'id': widget.course.departmentId,
                    'name': widget.deptName,
                  },
                );
              },
            ),
            body: CustomScrollView(
              slivers: [
                // ── Dynamic Banner ─────────────────────────────
                SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      'http://192.168.195.198:8000/${widget.course.photo}',
                      width: double.infinity,
                      height: 300.h,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 200.h,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.broken_image,
                          size: 40.r,
                          color: AppColor.gray3,
                        ),
                      ),
                      loadingBuilder: (ctx, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200.h,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes!)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 250.w,
                      height: forumPx,
                      child: OutlinedButton(
                        onPressed: () {
                          context.go(
                            AppRoutesNames.pendingSections,
                            extra: {
                              'course': widget.course,
                              'deptName': widget.deptName,
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
                          'التسجيل المؤقت',
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

                // ── Dynamic Title & Meta ───────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course name
                        Text(
                          widget.course.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        Text(
                          widget.course.description,
                          style: TextStyle(
                              fontSize: 14.sp, color: AppColor.textDarkBlue),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                // // ── Tabs ────────────────────────────────
                // SliverPersistentHeader(
                //   pinned: true,
                //   delegate: _TabBarDelegate(
                //     const [
                //       Tab(text: 'خصومات'),
                //     ],
                //     pinned: _tabsPinned,
                //     isScrollable: true,
                //   ),
                // ),
                //
                // // ── Tab Body ─────────────────────────────
                // SliverFillRemaining(
                //   child: Stack(
                //     children: [
                //       TabBarView(
                //         children: [
                //           // Pass the actual description into CourseInfoTab:
                //           const DiscountsTab(),
                //         ],
                //       ),
                //       if (!_tabsPinned)
                //         Positioned.fill(
                //           child: Container(
                //             color: AppColor.background.withOpacity(0.8),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscountsTab extends StatelessWidget {
  const DiscountsTab({Key? key}) : super(key: key);

  final List<Map<String, String>> _offers = const [
    {
      'title': 'خصم 50٪ للمبتدئين',
      'subtitle': 'سجل الآن وابدأ تعلم اللغة الإنجليزية بخصم نصف السعر.',
    },
    {
      'title': 'خصم 30٪ للطلبة',
      'subtitle': 'احصل على عرض خاص للطلبة عند التسجيل في غضون ٧ أيام.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: _offers.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final offer = _offers[index];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.purple,
                AppColor.purple.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          padding: EdgeInsets.all(20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FaIcon(
                FontAwesomeIcons.gift,
                color: Colors.white,
                size: 28.r,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer['title']!,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      offer['subtitle']!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 20.r,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Fades the TabBar until it’s scrolled into its pinned position
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final List<Tab> _tabs;
  final bool pinned;
  final bool isScrollable;

  _TabBarDelegate(this._tabs,
      {required this.pinned, this.isScrollable = false});

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
          isScrollable: isScrollable,
          indicatorColor: AppColor.textDarkBlue,
          labelColor: AppColor.textDarkBlue,
          dividerColor: AppColor.background,
          unselectedLabelColor: AppColor.gray3,
          labelStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,),
          tabs: _tabs,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.pinned != pinned ||
          old._tabs != _tabs ||
          old.isScrollable != isScrollable;
}


