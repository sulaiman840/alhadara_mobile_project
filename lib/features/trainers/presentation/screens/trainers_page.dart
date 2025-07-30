import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import '../../cubit/trainers_cubit.dart';
import '../../cubit/trainers_state.dart';
import '../widgets/trainer_card.dart';
import '../../data/models/trainer_with_course_model.dart';
import '../../../../core/navigation/routes_names.dart';

class TrainersPage extends StatelessWidget {
  const TrainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc    = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final theme  = Theme.of(context);

    return Directionality(
      textDirection: locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBarTitle(
          title: loc.tr('trainers_title'),
        ),
        body: BlocBuilder<TrainersCubit, TrainersState>(
          builder: (ctx, state) {
            if (state is TrainersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TrainersError) {
              return Center(
                child: Text(
                  loc.tr('trainers_error'),
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }

            final raw = (state as TrainersLoaded).trainers;
            if (raw.isEmpty) {
              return Center(
                child: Text(
                  loc.tr('trainers_no_items'),
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }


            final byId = <int, TrainerWithCourse>{};
            for (var tc in raw) {
              byId.putIfAbsent(tc.trainer.id, () => tc);
            }
            final unique = byId.values.toList();

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
                  final tc    = unique[i];
                  final image = tc.trainer.photo != null
                      ? '${ConstString.baseURl}${tc.trainer.photo}'
                      : null;

                  return TrainerCard(
                    name:        tc.trainer.name,
                    specialty:   tc.trainer.specialization,
                    imageUrl:    image,
                    onTap: () {
                      final courses = raw
                          .where((e) => e.trainer.id == tc.trainer.id)
                          .map((e) => e.course.toJson())
                          .toList();
                      context.push(
                        AppRoutesNames.trainersDetails,
                        extra: {
                          'trainer': tc.trainer.toJson(),
                          'courses': courses,
                        },
                      );
                    },
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
