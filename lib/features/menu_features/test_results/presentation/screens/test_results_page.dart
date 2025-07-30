import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';

import '../widgets/test_result_tile.dart';
import '../../cubit/grades_cubit.dart';
import '../../cubit/grades_state.dart';

class TestResultsPage extends StatelessWidget {
  const TestResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: loc.tr('test_results_title')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: BlocBuilder<GradesCubit, GradesState>(
          builder: (context, state) {
            if (state is GradesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GradesError) {
              return Center(
                child: Text(
                  loc.tr('test_results_error'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (state is GradesLoaded) {
              final grades = state.grades;
              if (grades.isEmpty) {
                return Center(
                  child: Text(
                    loc.tr('no_test_results'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.only(top: 24.h),
                itemCount: grades.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (ctx, idx) {
                  return TestResultTile(model: grades[idx]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}