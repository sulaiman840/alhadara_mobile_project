import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

import '../../../my_course_details/cubit/my_courses_cubit.dart';
import '../../../saved courses/cubit/saved_courses_cubit.dart';
import '../widgets/my_courses_list_widgets/my_courses_body.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyCoursesCubit>().fetchFirstPage(perPage: 10);
    context.read<SavedCoursesCubit>().fetchSaved();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(title: loc.tr('my_courses_title')),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: const MyCoursesBody(),
          ),
        ),
      ),
    );
  }
}
