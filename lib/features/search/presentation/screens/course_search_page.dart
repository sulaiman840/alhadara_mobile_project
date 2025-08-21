import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
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
      // keep your current cubit behavior
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
    final loc   = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: loc.tr('search_title'), // ex: "Search"
        onBack: () => context.go(AppRoutesNames.home),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Column(
          children: [
            // ─── Search Bar ─────────────────────────────────────────────
            BlocBuilder<SearchCubit, SearchState>(
              builder: (ctx, state) {
                final showClear =
                    _searchCtl.text.isNotEmpty || state is! SearchInitial;

                return Container(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                        theme.colorScheme.onSurface.withOpacity(0.06),
                        blurRadius: 6.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 22.r,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _searchCtl,
                          textAlign: TextAlign.right, // keep RTL typing feel
                          decoration: InputDecoration(
                            hintText: loc.tr('search_hint'),
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            suffixIcon: showClear
                                ? IconButton(
                              splashRadius: 18.r,
                              icon: Icon(
                                Icons.clear,
                                size: 20.r,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                              onPressed: () {
                                _searchCtl.clear();
                                context
                                    .read<SearchCubit>()
                                    .emit(SearchInitial());
                                setState(() {});
                              },
                            )
                                : null,
                          ),
                          style: theme.textTheme.bodyMedium,
                          onChanged: (v) {
                            setState(() {}); // update clear button state
                            _onQueryChanged(v);
                          },
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
                    return Center(
                      child: Text(
                        loc.tr('search_start'),
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (state is SearchLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }
                  if (state is SearchFailure) {
                    return Center(
                      child: Text(
                        state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : loc.tr('complaints_error'),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // Success
                  final courses = (state as SearchSuccess).result.courses;
                  if (courses.isEmpty) {
                    return Center(
                      child: Text(
                        loc.tr('search_no_results'),
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${loc.tr('results_count')} ${courses.length} ${loc.tr('in_label')} "${_searchCtl.text}"',
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 12.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: courses.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (ctx, i) {
                            final c = courses[i];
                            final imageUrl =
                            c.photo.isNotEmpty ? _normalizeUrl(c.photo) : null;

                            return InkWell(
                              onTap: () => context.pushNamed(
                                'courseDetails',
                                extra: {'course': c.toJson(), 'deptName': ''},
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.06),
                                      blurRadius: 6.r,
                                      offset: Offset(0, 2.h),
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
                                            _placeholder(theme),
                                      )
                                          : _placeholder(theme),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            c.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurface
                                                  .withOpacity(0.7),
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
    );
  }

  Widget _placeholder(ThemeData theme) => Container(
    width: 80.w,
    height: 60.h,
    color: theme.colorScheme.onSurface.withOpacity(0.08),
    child: Icon(
      Icons.image_not_supported_outlined,
      size: 28.r,
      color: theme.colorScheme.onSurface.withOpacity(0.45),
    ),
  );
}
