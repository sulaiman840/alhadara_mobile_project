import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/app_colors.dart';
import '../../cubit/ratings_cubit.dart';
import '../../cubit/ratings_state.dart';
import '../../../ratings/data/models/rating_model.dart';
import '../../../../../core/localization/app_localizations.dart';

class SectionRatingWidget extends StatelessWidget {
  final int sectionId;

  const SectionRatingWidget({Key? key, required this.sectionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context);

    return BlocBuilder<RatingsCubit, RatingsState>(
      builder: (ctx, state) {
        if (state is RatingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RatingsFailure) {
          return Center(
            child: Text(
              state.message,
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (state is RatingsLoaded) {
          final avg = state.page.averageRating;
          final list = state.page.ratings;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _showCommentsSheet(context, list),
                    icon: Icon(Icons.comment, color: scheme.primary),
                    label: Text(
                      _t(loc, 'show_comments', fallbackAr: 'عرض التعليقات', fallbackEn: 'Show comments'),
                      style: textTheme.bodyMedium?.copyWith(color: scheme.primary),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    avg.toStringAsFixed(1),
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: AppColor.yellow,
                    size: 16.sp,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: scheme.primary),
                    onPressed: () => _showRatingDialog(context, avg),
                    tooltip: _t(loc, 'rate_section_title', fallbackAr: 'قيّم هذا القسم', fallbackEn: 'Rate this section'),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showRatingDialog(BuildContext context, double avgRating) {
    final loc = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isArabic = Localizations.localeOf(context).languageCode.toLowerCase().startsWith('ar');
    final textDir = isArabic ? TextDirection.rtl : TextDirection.ltr;

    final initial = avgRating.round().clamp(1, 5);
    final rating = ValueNotifier<int>(initial);
    final comment = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: textDir,
        child: AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            _t(loc, 'rate_section_title', fallbackAr: 'قيّم هذا القسم', fallbackEn: 'Rate this section'),
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: rating,
                builder: (_, val, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < val;
                    return IconButton(
                      icon: Icon(
                        filled ? Icons.star : Icons.star_border,
                      ),
                      color: AppColor.yellow,
                      onPressed: () => rating.value = i + 1,
                    );
                  }),
                ),
              ),
              TextField(
                controller: comment,
                autofocus: true,
                cursorColor: scheme.primary,
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
                decoration: InputDecoration(
                  hintText: _t(loc, 'add_comment_hint', fallbackAr: 'أضف تعليقاً', fallbackEn: 'Add a comment'),
                  hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.6)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: scheme.primary),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                _t(loc, 'cancel', fallbackAr: 'إلغاء', fallbackEn: 'Cancel'),
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
              onPressed: () {
                context.read<RatingsCubit>().submitSectionRating(
                  sectionId: sectionId,
                  rating: rating.value,
                  comment: comment.text.isEmpty ? null : comment.text,
                );
                Navigator.pop(context);
              },
              child: Text(
                _t(loc, 'send', fallbackAr: 'إرسال', fallbackEn: 'Send'),
                style: textTheme.bodyMedium?.copyWith(color: scheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, List<RatingModel> comments) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode.toLowerCase().startsWith('ar');
    final textDir = isArabic ? TextDirection.rtl : TextDirection.ltr;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Directionality(
        textDirection: textDir,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollCtrl) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: scheme.onSurface.withValues(alpha: 0.7)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      _t(loc, 'comments_title', fallbackAr: 'التعليقات', fallbackEn: 'Comments'),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 18.w),
                  ],
                ),
                SizedBox(height: 8.h),
                Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                Expanded(
                  child: comments.isEmpty
                      ? Center(
                    child: Text(
                      _t(loc, 'no_comments_yet', fallbackAr: 'لا توجد تعليقات بعد', fallbackEn: 'No comments yet'),
                      style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7)),
                    ),
                  )
                      : ListView.separated(
                    controller: scrollCtrl,
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (_, i) {
                      final r = comments[i];
                      return Card(
                        color: Theme.of(context).cardColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: scheme.primary.withValues(alpha: 0.1),
                                child: FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color:  AppColor.yellow,
                                  size: 16.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // name + comment
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.student.name,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: scheme.onSurface,
                                      ),
                                    ),
                                    if (r.comment != null && r.comment!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                          r.comment!,
                                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.9)),
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
            ),
          ),
        ),
      ),
    );
  }


  String _t(
      AppLocalizations loc,
      String key, {
        required String fallbackAr,
        required String fallbackEn,
      }) {
    try {
      final v = loc.tr(key);
      if (v.isNotEmpty && v != key) return v;
    } catch (_) {}

    final isArabic = loc.locale.languageCode.toLowerCase().startsWith('ar');
    return isArabic ? fallbackAr : fallbackEn;
  }
}
