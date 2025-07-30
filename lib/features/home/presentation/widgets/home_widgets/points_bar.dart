import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../cubit/points_cubit.dart';
import '../../../cubit/points_state.dart';

class PointsBar extends StatelessWidget {
  const PointsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<PointsCubit, PointsState>(
      builder: (context, state) {
        Widget content;
        if (state is PointsLoading) {
          content = const SizedBox(
            width: 16, height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          );
        } else if (state is PointsFailure) {
          content = Text(loc.tr('points_error'),
              style: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(color: Colors.white));
        } else if (state is PointsSuccess) {
          content = Text(
            '${state.points} ${loc.tr('points_label')}',
            style: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          );
        } else {
          content = const SizedBox.shrink();
        }

        return Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColor.purple,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Row(
            children: [
              SizedBox(width: 10.w),
              FaIcon(FontAwesomeIcons.graduationCap, color: Colors.white, size: 20.r),
              SizedBox(width: 8.w),
              Text(loc.tr('points_title'),
                  style: Theme.of(context).textTheme.bodyMedium!
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
              Spacer(),
              content,
              SizedBox(width: 10.w),
            ],
          ),
        );
      },
    );
  }
}
