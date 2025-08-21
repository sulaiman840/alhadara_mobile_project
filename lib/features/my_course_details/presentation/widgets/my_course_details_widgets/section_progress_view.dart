import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../cubit/section_progress_cubit.dart';
import '../../../cubit/section_progress_state.dart';

class SectionProgressView extends StatelessWidget {
  final int sectionId;
  const SectionProgressView({super.key, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SectionProgressCubit, SectionProgressState>(
      builder: (ctx, state) {

        if (state is SectionProgressInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {

            final current = ctx.read<SectionProgressCubit>().state;
            if (current is SectionProgressInitial) {
              ctx.read<SectionProgressCubit>().load(sectionId);
            }
          });
        }

        if (state is SectionProgressLoading || state is SectionProgressInitial) {
          return SizedBox(
            width: 44.r,
            height: 44.r,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            ),
          );
        }

        if (state is SectionProgressFailure) {
          // Subtle fallback keeps layout stable
          return Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            child: Text('—', style: theme.textTheme.bodySmall),
          );
        }

        final progress = (state as SectionProgressSuccess).progress;
        return CircularPercentIndicator(
          radius: 20.r,
          lineWidth: 4.r,
          animation: true,
          animationDuration: 900,
          percent: (progress / 100.0).clamp(0.0, 1.0),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
          progressColor: theme.colorScheme.primary,
          center: Text(
            '$progress%',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
