import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/my_courses_cubit.dart';
import '../../cubit/my_courses_state.dart';
import '../widgets/my_course_details_widgets/course_details_body.dart';


class MyCourseDetailsPage extends StatefulWidget {
  final int enrolledId;
  const MyCourseDetailsPage({super.key, required this.enrolledId});

  @override
  State<MyCourseDetailsPage> createState() => _MyCourseDetailsPageState();
}

class _MyCourseDetailsPageState extends State<MyCourseDetailsPage> {
  bool _tabsPinned = false;


  late final double bannerPx = 300.h;
  late final double forumPx = 48.h;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MyCoursesCubit>();
    if (cubit.state is! MyCoursesSuccess) {
      cubit.fetchFirstPage(perPage: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pinThreshold = bannerPx + forumPx / 2 - kToolbarHeight;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: NotificationListener<ScrollNotification>(
          onNotification: (sn) {
            if (sn.depth != 0) return false;
            final shouldPin = sn.metrics.pixels >= pinThreshold;
            if (shouldPin != _tabsPinned) setState(() => _tabsPinned = shouldPin);
            return false;
          },
          child: BlocBuilder<MyCoursesCubit, MyCoursesState>(
            builder: (ctx, state) {
              final title = _deriveTitle(state, loc, widget.enrolledId);
              return Scaffold(
                backgroundColor: theme.colorScheme.surface,
                appBar: CustomAppBar(title: title),
                body: CourseDetailsBody(
                  state: state,
                  enrolledId: widget.enrolledId,
                  bannerPx: bannerPx,
                  forumPx: forumPx,
                  tabsPinned: _tabsPinned,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _deriveTitle(MyCoursesState state, AppLocalizations loc, int enrolledId) {
    if (state is MyCoursesSuccess) {
      final enrolled = state.courses.firstWhere(
            (e) => e.id == enrolledId,
        orElse: () => throw Exception('Enrolled section not found: $enrolledId'),
      );
      return enrolled.course.name.isNotEmpty
          ? enrolled.course.name
          : loc.tr('course_details_default_title');
    }
    return loc.tr('course_details_default_title');
  }
}