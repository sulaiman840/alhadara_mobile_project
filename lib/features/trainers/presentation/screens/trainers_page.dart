// lib/features/trainers/presentation/screens/trainers_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class Trainer {
  final String name;
  final String specialty;
  final String imagePath;
  final int courses;

  const Trainer({
    required this.name,
    required this.specialty,
    required this.imagePath,
    required this.courses,
  });
}

class TrainersPage extends StatelessWidget {
  const TrainersPage({Key? key}) : super(key: key);

  static final _trainers = <Trainer>[
    Trainer(
      name: 'مريم علي',
      specialty:  'لغة انكليزية ',
      imagePath: 'assets/images/girl2.jpg',
      courses: 2,
    ),
    Trainer(
      name: 'حسن علي',
      specialty: 'تطوير تطبيقات',
      imagePath: 'assets/images/man3.jpg',
      courses: 4,
    ),
    Trainer(
      name: 'مريم علي',
      specialty: 'تخصص طبخ',
      imagePath: 'assets/images/girl3.jpg',
      courses: 4,
    ),
    Trainer(
      name: 'محمود مصطفى',
      specialty: 'لغة المانية',
      imagePath: 'assets/images/man2.jpg',
      courses: 2,
    ),
    Trainer(
      name: 'علي محمد',
      specialty: 'تخصص Laravel',
      imagePath: 'assets/images/man.png',
      courses: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'المدربين',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                        color: AppColor.textDarkBlue),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Grid of trainers
              Expanded(
                child: GridView.builder(
                  itemCount: _trainers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (ctx, i) {
                    final trainer = _trainers[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        // navigate to details, passing the trainer
                        context.go(
                          AppRoutesNames.trainersDetails,
                          extra: trainer,
                        );
                      },
                      child: _TrainerCard(trainer: trainer),
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

class _TrainerCard extends StatelessWidget {
  final Trainer trainer;

  const _TrainerCard({required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.background,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Stack(
        children: [
          // photo + details
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 170.h,
                child: Image.asset(trainer.imagePath, fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                child: Column(
                  children: [
                    Text(
                      trainer.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      trainer.specialty,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: AppColor.gray3),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // badge at top-right
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColor.purple,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                'دورات ${trainer.courses}',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
