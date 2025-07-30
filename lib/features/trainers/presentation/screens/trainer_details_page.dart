import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/const.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../data/models/trainer_with_course_model.dart';
import '../widgets/trainer_banner.dart';
import '../widgets/trainer_info_section.dart';
import '../widgets/course_list_section.dart';

class TrainerDetailsPage extends StatelessWidget {
  final Trainer trainer;
  final List<Course> courses;

  const TrainerDetailsPage({
    super.key,
    required this.trainer,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = (trainer.photo?.isNotEmpty ?? false)
        ? '${ConstString.baseURl}${trainer.photo}'
        : 'assets/images/placeholder.png';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).tr('trainer_details_title'),
      ),
      body: CustomScrollView(
        slivers: [
          TrainerBanner(photoUrl: photoUrl),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(64.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TrainerInfoSection(trainer: trainer),
                  SizedBox(height: 24.h),
                  CourseListSection(courses: courses),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
