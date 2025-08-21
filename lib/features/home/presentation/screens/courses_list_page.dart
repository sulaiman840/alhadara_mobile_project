import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../cubit/courses_cubit.dart';
import '../widgets/courses_list_widgets/courses_list_body.dart';

class CoursesListPage extends StatefulWidget {
  final int departmentId;
  final String departmentName;

  const CoursesListPage({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  State<CoursesListPage> createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursesCubit>().fetchCourses(widget.departmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: '${loc.tr('courses_list_title')} ${widget.departmentName}',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: CoursesListBody(
            departmentId: widget.departmentId,
            departmentName: widget.departmentName,
          ),
        ),
      ),
    );
  }
}
