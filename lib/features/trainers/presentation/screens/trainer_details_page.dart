
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../ratings/cubit/ratings_cubit.dart';
import '../../../ratings/cubit/ratings_state.dart';
import '../../data/models/trainer_with_course_model.dart';

class TrainerDetailsPage extends StatelessWidget {
  final TrainerWithCourse trainerWithCourse;
  const TrainerDetailsPage({
    Key? key,
    required this.trainerWithCourse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = trainerWithCourse.trainer;
    final c = trainerWithCourse.course;
    // build full URLs or fall back to placeholder asset
    final photoUrl = t.photo != null
        ? '${ConstString.baseURl}${t.photo}'
        : 'assets/images/placeholder.png';
    final courseImageUrl = c.photo.isNotEmpty
        ? '${ConstString.baseURl}${c.photo}'
        : 'assets/images/placeholder.png';
    // format the created date as “duration”
    final duration = '${c.createdAt.day}/${c.createdAt.month}/${c.createdAt.year}';

    // our “mock” list of courses (API only has one per trainer)
    final courses = [c];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'تفاصيل المدرب',
        ),
        body: CustomScrollView(
          slivers: [
            // ── Banner ─────────────────────────────
            SliverAppBar(
              pinned: false,
              expandedHeight: 250.h,
              backgroundColor: AppColor.background,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: photoUrl.startsWith('http')
                    ? Image.network(photoUrl, fit: BoxFit.contain)
                    : Image.asset(photoUrl, fit: BoxFit.contain),
              ),
            ),

            // ── Details + Courses ──────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(64.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Trainer Info
                    Text(
                      t.name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      t.specialization,
                      style: TextStyle(fontSize: 14.sp, color: AppColor.gray3),
                    ),
                    SizedBox(height: 16.h),

                    // Bio / experience
                    Text(
                      'نبذة عن المدرب',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      t.experience,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textDarkBlue,
                        height: 1.4,
                      ),
                    ),

// // ── Ratings header ─────────────────────────
//                     SizedBox(height: 24.h),
//                     Text(
//                       'تقييم المدرب',
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.textDarkBlue,
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//
// // ── Ratings list / average ─────────────────
//                     BlocBuilder<RatingsCubit, RatingsState>(
//                       builder: (ctx, state) {
//                         if (state is RatingsLoading) {
//                           return const Center(child: CircularProgressIndicator());
//                         }
//                         if (state is RatingsFailure) {
//                           print(state.message);
//                           return Text(state.message, style: TextStyle(color: Colors.red));
//                         }
//                         if (state is RatingsLoaded) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               // Average rating
//                               Text(
//                                 'متوسط التقييم: ${state.page.averageRating.toStringAsFixed(1)} ★',
//                                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
//                               ),
//                               SizedBox(height: 8.h),
//                               // Individual ratings
//                               ...state.page.ratings.map((r) => Padding(
//                                 padding: EdgeInsets.only(bottom: 8.h),
//                                 child: ListTile(
//                                   leading: CircleAvatar(
//                                     backgroundImage: NetworkImage(
//                                       '${ConstString.baseURl}${r.student.photo}',
//                                     ),
//                                   ),
//                                   title: Text(
//                                     r.comment,
//                                     style: TextStyle(fontSize: 14.sp),
//                                   ),
//                                   subtitle: Text('${r.student.name} • ${r.rating} ★'),
//                                 ),
//                               )),
//                             ],
//                           );
//                         }
//                         return const SizedBox.shrink();
//                       },
//                     ),
//
// // ── “Rate Trainer” button ───────────────────
//                     SizedBox(height: 16.h),
//                     ElevatedButton(
//                       onPressed: () async {
//                         final cubit = context.read<RatingsCubit>();
//                         final result = await showDialog<_RatingInput>(
//                           context: context,
//                           builder: (_) {
//                             var _stars = 5;
//                             var _commentCtl = TextEditingController();
//                             return AlertDialog(
//                               title: const Text('قيم المدرب'),
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   // simple star picker:
//                                   DropdownButton<int>(
//                                     value: _stars,
//                                     items: List.generate(5, (i) => i+1)
//                                         .map((s) => DropdownMenuItem(value: s, child: Text('$s ★')))
//                                         .toList(),
//                                     onChanged: (v) => _stars = v ?? 5,
//                                   ),
//                                   TextField(
//                                     controller: _commentCtl,
//                                     decoration: const InputDecoration(labelText: 'تعليقك'),
//                                   ),
//                                 ],
//                               ),
//                               actions: [
//                                 TextButton(onPressed: () => Navigator.pop(_, null), child: const Text('إلغاء')),
//                                 ElevatedButton(
//                                   onPressed: () => Navigator.pop(_, _RatingInput(_stars, _commentCtl.text)),
//                                   child: const Text('إرسال'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//
//                         if (result != null) {
//                           await cubit.submitTrainerRating(
//                             trainerId: trainerWithCourse.trainer.id,
//                             sectionId: trainerWithCourse.course.id,
//                             rating: result.stars,
//                             comment: result.comment,
//                           );
//                           // refresh after submit:
//                           cubit.loadTrainerRatings(trainerWithCourse.trainer.id, trainerWithCourse.course.id);
//                         }
//                       },
//                       child: const Text('قيم المدرب'),
//                     ),
                    SizedBox(height: 24.h),

                    // Courses Header
                    Text(
                      'كورسات (${courses.length})',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Course items
                    ...courses.map((course) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: InkWell(
                          onTap: () {
                            // TODO: navigate to course details if desired
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.background,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.textDarkBlue.withOpacity(0.5),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                // Course thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: courseImageUrl.startsWith('http')
                                      ? Image.network(
                                    courseImageUrl,
                                    width: 60.w,
                                    height: 60.h,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    courseImageUrl,
                                    width: 60.w,
                                    height: 60.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Title + duration
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.textDarkBlue,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        duration,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColor.gray3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Arrow icon
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.r,
                                  color: AppColor.gray3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _RatingInput {
  final int stars;
  final String comment;
  _RatingInput(this.stars, this.comment);
}
