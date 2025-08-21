import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/finished_courses_cubit.dart';
import '../../cubit/finished_courses_state.dart';
import '../widgets/finished_course_tile.dart';

class FinishedCoursesPage extends StatelessWidget {
  const FinishedCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: loc.tr('finished_courses_title')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: BlocBuilder<FinishedCoursesCubit, FinishedCoursesState>(
          builder: (context, state) {
            if (state is FinishedCoursesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FinishedCoursesError) {
              return Center(
                child: Text(
                  state.errorMessage.isNotEmpty
                      ? state.errorMessage
                      : loc.tr('finished_courses_error'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (state is FinishedCoursesLoaded) {
              final items = state.courses;
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    loc.tr('finished_courses_no_items'),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.only(top: 24.h),
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (_, i) => FinishedCourseTile(model: items[i]),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
