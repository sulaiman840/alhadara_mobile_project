import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/injection.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../cubit/quiz_cubit.dart';
import '../../../cubit/section_files_cubit.dart';
import '../tabs/course_info_tab.dart';
import '../tabs/homework_tab.dart';
import '../tabs/tab_bar_delegate.dart';
import '../tabs/tests_tab.dart';

class TabsSection {
  static List<Widget> buildSlivers({
    required bool pinned,
    required int sectionId,
    required String description,
    required AppLocalizations loc,
  }) {
    return [
      SliverPersistentHeader(
        pinned: true,
        delegate: TabBarDelegate(
          tabs: [
            Tab(text: loc.tr('tab_course_info')),
            Tab(text: loc.tr('tab_homework')),
            Tab(text: loc.tr('tab_tests')),
          ],
          pinned: pinned,
        ),
      ),
      SliverOpacity(
        opacity: pinned ? 1.0 : 0.5,
        sliver: SliverFillRemaining(
          child: TabBarView(
            children: [
              CourseInfoTab(description: description, loc: loc),
              BlocProvider<SectionFilesCubit>(
                create: (_) => getIt<SectionFilesCubit>()..fetchFiles(sectionId),
                child: HomeworkTab(sectionId: sectionId, loc: loc),
              ),
              BlocProvider<QuizCubit>(
                create: (_) => getIt<QuizCubit>()..fetchQuizzes(sectionId),
                child: TestsTab(sectionId: sectionId),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}