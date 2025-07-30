import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../cubit/schedule_cubit.dart';
import '../../cubit/schedule_state.dart';
import 'schedule_item_card.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (_, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ScheduleError) {
          return Center(
            child: Text(
              '${loc.tr('schedule_error')}: ${state.message}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        if (state is ScheduleLoaded) {
          final events = state.events;
          if (events.isEmpty) {
            return Center(
              child: Text(
                loc.tr('no_schedule_items'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            itemCount: events.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, i) => ScheduleItemCard(event: events[i]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
