import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/schedule_cubit.dart';
import '../widgets/days_selector.dart';
import '../widgets/schedule_list.dart';

class WeeklyActivityPage extends StatefulWidget {
  const WeeklyActivityPage({super.key});

  @override
  State<WeeklyActivityPage> createState() => _WeeklyActivityPageState();
}

class _WeeklyActivityPageState extends State<WeeklyActivityPage> {
  final _daysSlug = [
    'saturday','sunday','monday','tuesday','wednesday','thursday','friday'
  ];

  int _selectedIndex = (DateTime.now().weekday + 1) % 7;

  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>()
        .fetchByDay(_daysSlug[_selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final days = [
      'day_saturday',
      'day_sunday',
      'day_monday',
      'day_tuesday',
      'day_wednesday',
      'day_thursday',
      'day_friday',
    ].map(loc.tr).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: loc.tr('weekly_activity_title'),
          onBack: () => GoRouter.of(context).pop(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.tr('weekly_activity_header'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16.h),

              DaysSelector(
                days: days,
                selectedIndex: _selectedIndex,
                onDaySelected: (i) {
                  setState(() => _selectedIndex = i);
                  context.read<ScheduleCubit>().fetchByDay(_daysSlug[i]);
                },
              ),
              SizedBox(height: 24.h),

              Text(
                loc.tr('today_label'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12.h),

              Expanded(child: ScheduleList()),
            ],
          ),
        ),
      ),
    );
  }
}
