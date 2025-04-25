
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class CourseDetailsPage extends StatefulWidget {
  const CourseDetailsPage({Key? key}) : super(key: key);

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

    // Scale them to actual logical pixels
    final bannerPx = bannerHeight.h;
    final forumPx = forumBtnH.h;
    // When scroll offset reaches this, the tabs are “pinned”
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
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
              onBack: () => context.go(AppRoutesNames.coursesList),
            ),
            body: CustomScrollView(
              slivers: [
                // ── Banner ─────────────────────────────
                SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      'assets/images/English.jpg',
                      width: double.infinity,
                      height: 200.h,
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
                          // TODO: Navigate to forum
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

                // ── Title & Meta ───────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كورس لغة انجليزية: للمبتدئين',
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
                                color: Colors.green.withValues(alpha: 0.2),
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
                      Tab(text: 'خصومات'),
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
                         DiscountsTab(),

                        ],
                      ),
                      if (!_tabsPinned)
                        Positioned.fill(
                          child: Container(
                            color: AppColor.background.withValues(alpha: 0.8),
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


/// Tab 1: course information
class CourseInfoTab extends StatelessWidget {
  const CourseInfoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('وصف الكورس',
              style: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.textDarkBlue)),
          SizedBox(height: 8.h),
          Text(
            'في هذا الكورس سنتعلم أساسيات اللغة الإنجليزية للمبتدئين: قواعد بسيطة، مفردات يومية، ومهارات المحادثة.',
            style: TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue),
          ),
          SizedBox(height: 16.h),

          Text('أهداف الكورس',
              style: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.textDarkBlue)),
          SizedBox(height: 8.h),
          _buildBullet('فهم الحروف والأصوات الإنجليزية'),
          _buildBullet('تعلّم مفردات الاستخدام اليومي'),
          _buildBullet('بناء جمل بسيطة'),
          _buildBullet('مهارات الاستماع والمحادثة الأولية'),
          SizedBox(height: 16.h),

          Text('المتطلبات',
              style: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.textDarkBlue)),
          SizedBox(height: 8.h),
          _buildBullet('لا يتطلب معرفة سابقة بالإنجليزية'),
          _buildBullet('الرغبة في التعلم والتدريب اليومي'),
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
            child: Text(text,
                style: TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class DiscountsTab extends StatelessWidget {
  const DiscountsTab({Key? key}) : super(key: key);

  // Sample offers data
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
