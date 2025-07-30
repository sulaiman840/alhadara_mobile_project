// lib/features/search/presentation/screens/course_search_page.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/search_cubit.dart';
import '../../cubit/search_state.dart';
import '../../../../core/utils/const.dart';

class CourseSearchPage extends StatefulWidget {
  const CourseSearchPage({Key? key}) : super(key: key);

  @override
  _CourseSearchPageState createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  final _searchCtl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtl.dispose();
    super.dispose();
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    final trimmed = q.trim();
    if (trimmed.isEmpty) {
      context.read<SearchCubit>().emit(SearchInitial());
    } else {
      _debounce = Timer(const Duration(milliseconds: 500), () {
        context.read<SearchCubit>().search(trimmed);
      });
    }
  }

  String _normalizeUrl(String photoPath) {
    final base = ConstString.baseURl.endsWith('/')
        ? ConstString.baseURl
        : '${ConstString.baseURl}/';
    return Uri.parse(base).resolve(photoPath).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'بحث',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            children: [
              // ─── Search Bar ─────────────────────────────────────────────
              BlocBuilder<SearchCubit, SearchState>(
                builder: (ctx, state) {
                  final showClear = _searchCtl.text.isNotEmpty || state is! SearchInitial;
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TextField(
                              controller: _searchCtl,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                icon: Icon(Icons.search, color: AppColor.gray3),
                                hintText: 'ابحث عن الكورس',
                                hintStyle: TextStyle(color: AppColor.gray3),
                                border: InputBorder.none,
                                suffixIcon: showClear
                                    ? IconButton(
                                  icon: Icon(Icons.clear, color: AppColor.gray3),
                                  onPressed: () {
                                    _searchCtl.clear();
                                    context.read<SearchCubit>().emit(SearchInitial());
                                  },
                                )
                                    : null,
                              ),
                              style: TextStyle(color: AppColor.textDarkBlue),
                              onChanged: _onQueryChanged,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // ─── Results Area ───────────────────────────────────────────
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return const Center(
                        child: Text(
                          'ابحث لبدء',
                          style: TextStyle(color: AppColor.textDarkBlue),
                        ),
                      );
                    }
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is SearchFailure) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue),
                        ),
                      );
                    }
                    // SearchSuccess
                    final courses = (state as SearchSuccess).result.courses;
                    if (courses.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد نتائج',
                          style: TextStyle(fontSize: 14.sp, color: AppColor.textDarkBlue),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${courses.length} كورسات في "${_searchCtl.text}"',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textDarkBlue,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Expanded(
                          child: ListView.separated(
                            itemCount: courses.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (ctx, i) {
                              final c = courses[i];
                              final imageUrl = c.photo.isNotEmpty
                                  ? _normalizeUrl(c.photo)
                                  : null;
                              return InkWell(
                                onTap: () => context.pushNamed(
                                  'courseDetails',
                                  extra: {'course': c.toJson(), 'deptName': ''},
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: imageUrl != null
                                            ? Image.network(
                                          imageUrl,
                                          width: 80.w,
                                          height: 60.h,
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, _, __) =>
                                              Container(
                                                width: 80.w,
                                                height: 60.h,
                                                color: Colors.grey[200],
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 32.r,
                                                  color: AppColor.gray3,
                                                ),
                                              ),
                                        )
                                            : Container(
                                          width: 80.w,
                                          height: 60.h,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 32.r,
                                            color: AppColor.gray3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              c.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.textDarkBlue,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              c.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColor.gray3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
