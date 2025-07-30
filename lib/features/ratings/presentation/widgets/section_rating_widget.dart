
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit/ratings_cubit.dart';
import '../../cubit/ratings_state.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../ratings/data/models/rating_model.dart';

class SectionRatingWidget extends StatelessWidget {
  final int sectionId;

  const SectionRatingWidget({Key? key, required this.sectionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingsCubit, RatingsState>(
      builder: (ctx, state) {
        if (state is RatingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RatingsFailure) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColor.textDarkBlue),
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
                    icon: Icon(Icons.comment, color: AppColor.purple),
                    label: Text(
                      'عرض التعليقات ',
                      style: TextStyle(color: AppColor.purple),
                    ),
                  ),
                  Spacer(),
                  Text(
                    avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textDarkBlue,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: AppColor.yellow,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColor.purple),
                    onPressed: () => _showRatingDialog(context, avg),
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
    final initial = avgRating.round().clamp(1, 5);
    final _rating = ValueNotifier<int>(initial);
    final _comment = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: const Text(
          'قيّم هذا القسم',
          style: TextStyle(color: AppColor.textDarkBlue),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _rating,
              builder: (_, val, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < val ? Icons.star : Icons.star_border,
                      color: AppColor.yellow,
                    ),
                    onPressed: () => _rating.value = i + 1,
                  );
                }),
              ),
            ),

            TextField(
              controller: _comment,
              autofocus: true,
              cursorColor: AppColor.purple,
              style: TextStyle(
                color: AppColor.purple,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: 'أضف تعليقاً',
                hintStyle: TextStyle(color: AppColor.gray3),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.purple),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColor.textDarkBlue),
            ),),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColor.purple),
            ),
            onPressed: () {
              context.read<RatingsCubit>().submitSectionRating(
                    sectionId: sectionId,
                    rating: _rating.value,
                    comment: _comment.text.isEmpty ? null : _comment.text,
                  );
              Navigator.pop(context);
            },
            child: Text(
              'إرسال',
              style: TextStyle(
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, List<RatingModel> comments) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.gray3.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2.h),
                ),
              ),
              SizedBox(height: 12.h),

              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: AppColor.gray3),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),
                  Text(
                    'التعليقات',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textDarkBlue,
                    ),
                  ),
                  SizedBox(width: 18.w),
                ],
              ),
              SizedBox(height: 8.h),

              Divider(color: AppColor.gray3.withValues(alpha: 0.3)),

              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, i) {
                    final r = comments[i];
                    return Card(
                      color: AppColor.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor:
                                  AppColor.gray3.withValues(alpha: 0.2),
                              child: FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: AppColor.white,
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // name + stars + comment
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.student.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: AppColor.white,
                                    ),
                                  ),
                                  if (r.comment != null &&
                                      r.comment!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Text(
                                        r.comment!,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColor.white,
                                        ),
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
    );
  }
}
