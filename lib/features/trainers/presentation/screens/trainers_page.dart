// lib/features/trainers/presentation/screens/trainers_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/trainers_cubit.dart';
import '../../cubit/trainers_state.dart';
import '../../data/models/trainer_with_course_model.dart';

class TrainersPage extends StatelessWidget {
  const TrainersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: 'المدربين'),
        backgroundColor: AppColor.background,
        body: BlocBuilder<TrainersCubit, TrainersState>(
          builder: (ctx, state) {
            if (state is TrainersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TrainersError) {
              return Center(child: Text(state.message));
            }

            // Raw flat list: may contain multiple entries per trainer
            final raw = (state as TrainersLoaded).trainers;

            if (raw.isEmpty) {
              return const Center(child: Text('لا يوجد مدربين حالياً'));
            }

            // 1️⃣ Build a map to dedupe by trainer ID
            final Map<int, TrainerWithCourse> byTrainer = {};
            for (var tc in raw) {
              byTrainer.putIfAbsent(tc.trainer.id, () => tc);
            }
            // 2️⃣ Unique list of trainers
            final unique = byTrainer.values.toList();

            return Padding(
              padding: EdgeInsets.all(24.w),
              child: GridView.builder(
                itemCount: unique.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (_, i) {
                  final tc = unique[i];
                  final img = tc.trainer.photo != null
                      ? '${ConstString.baseURl}${tc.trainer.photo}'
                      : 'assets/images/placeholder.png';

                  return InkWell(
                    onTap: () {
                      // 3️⃣ Gather all courses for this trainer
                      final courses = raw
                          .where((e) => e.trainer.id == tc.trainer.id)
                          .map((e) => e.course)
                          .toList();
                      context.push(
                               AppRoutesNames.trainersDetails,
                                extra: {
                              'trainer': tc.trainer.toJson(),
                             'courses': courses.map((c) => c.toJson()).toList(),
                           },
                            );

                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: _TrainerCard(
                      name: tc.trainer.name,
                      specialty: tc.trainer.specialization,
                      imageUrl: img,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageUrl;

  const _TrainerCard({
    Key? key,
    required this.name,
    required this.specialty,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.background,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 170.h,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDarkBlue,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  specialty,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: AppColor.gray3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
