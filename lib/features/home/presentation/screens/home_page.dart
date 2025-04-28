import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';


class _Course {
  final String image;
  final String title;
  const _Course({required this.image, required this.title});
}

class _Category {
  final String label;
  final IconData icon;
  const _Category({required this.label, required this.icon});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _points = 50;

  // Data
  final List<_Course> _myCourses = const [
    _Course(image: 'assets/images/Flutter.png', title: 'Flutter للمبتدئين'),
    _Course(image: 'assets/images/laravel.png', title: 'Laravel متقدمة'),
    _Course(image: 'assets/images/Germany.jpg', title: 'لغة ألمانية'),
  ];

  final List<_Category> _categories = const [
    _Category(label: 'الطبخ', icon: FontAwesomeIcons.utensils),
    _Category(label: 'البرمجة', icon: FontAwesomeIcons.code),
    _Category(label: 'اللغة الإنجليزية', icon: FontAwesomeIcons.language),
    _Category(label: 'اللغة الألمانية', icon: FontAwesomeIcons.language),
    _Category(label: 'السياحة', icon: FontAwesomeIcons.planeArrival),
    _Category(label: 'التصميم', icon: FontAwesomeIcons.paintBrush),
  ];

  final List<_Course> _suggested = const [
    _Course(image: 'assets/images/programming.jpg', title: 'مبادئ البرمجة'),
    _Course(image: 'assets/images/cooking.jpg', title: 'كورس الطبخ'),
    _Course(image: 'assets/images/English.jpg', title: 'كورس إنجليزي'),
    _Course(image: 'assets/images/tourism.jpg', title: 'مبادئ السياحة'),
    _Course(image: 'assets/images/Adobe.png', title: 'كورس التصميم'),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(   appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 20.h),
            child: _buildHeader(),
          ),
        ),
      ),
        backgroundColor: AppColor.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  _buildSearchBar(),
                  SizedBox(height: 16.h),
                  _buildPointsCapsule(),
                  SizedBox(height: 16.h),
                  _buildCategoryChips(),
                  SizedBox(height: 24.h),
                  _buildSectionTitle('قائمة كورساتي'),
                  SizedBox(height: 12.h),
                  _buildMyCoursesCarousel(),
                  SizedBox(height: 24.h),
                  _buildSectionTitle('كورسات مقترحة'),
                  SizedBox(height: 12.h),
                  _buildSuggestedGrid(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final avatarSize = 40.r;
    return Row(
      children: [
        Text(
          'مرحبا بك ..!!',
          style: TextStyle(
            color: AppColor.textDarkBlue,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        _buildCircleIconButton(
          icon: FontAwesomeIcons.solidBell,
          onTap: () {GoRouter.of(context).go(AppRoutesNames.notifications);
          },
        ),
        SizedBox(width: 12.w),
        _buildCircleAvatar(
          imagePath: 'assets/images/man.png',
          onTap: () {GoRouter.of(context).go(AppRoutesNames.profile);}, // TODO: profile
        ),
      ],
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final avatarSize = 40.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.purple, width: 1.5.r),
        ),
        child: Center(
          child: FaIcon(icon, size: 18.r, color: AppColor.textDarkBlue),
        ),
      ),
    );
  }

  Widget _buildCircleAvatar({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    final avatarSize = 40.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.purple, width: 2.r),
        ),
        child: ClipOval(
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => GoRouter.of(context).go(AppRoutesNames.search),
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColor.gray3),
            SizedBox(width: 8.w),
            Text(
              'ابحث عن كورسات',
              style: TextStyle(color: AppColor.gray3, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCapsule() {
    return Container(
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColor.purple,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10.w),
                FaIcon(FontAwesomeIcons.graduationCap, color: Colors.white, size: 20.r),
                SizedBox(width: 8.w),
                Text(
                  'نقاطك الحالية',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('$_points نقطة',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500)),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          return GestureDetector(
            // onTap: () => context.go('${AppRoutesNames.categories}/${cat.label}'),
            onTap: () {  GoRouter.of(context).go(AppRoutesNames.coursesList);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColor.gray3),
              ),
              child: Row(
                children: [
                  FaIcon(cat.icon, size: 18.r, color: AppColor.purple),
                  SizedBox(width: 8.w),
                  Text(cat.label, style: TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.textDarkBlue),
      ),
    );
  }

  Widget _buildMyCoursesCarousel() {
    return SizedBox(
      height: 160.h,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 45.w),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _myCourses.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, i) {
                final c = _myCourses[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(c.image, width: 120.w, height: 120.h, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 120.w,
                      child: Text(c.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColor.textDarkBlue,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 20.r),
              onPressed: () {      GoRouter.of(context).go(AppRoutesNames.myCourses,);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _suggested.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, i) {
        final c = _suggested[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(c.image, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 8.h),
            Text(c.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: AppColor.purple, fontWeight: FontWeight.w500)),
          ],
        );
      },
    );
  }


}