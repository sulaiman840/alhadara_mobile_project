import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import '../../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/ads_cubit.dart';
import '../../cubit/ads_state.dart';
import '../widgets/ad_card.dart';

class ActiveAdsPage extends StatelessWidget {
  const ActiveAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: loc.tr('ads_title')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: BlocBuilder<AdsCubit, AdsState>(
          builder: (context, state) {
            if (state is AdsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AdsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.error, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              );
            }
            final ads = state is AdsLoaded ? state.page.ads : [];
            if (ads.isEmpty) {
              return Center(
                child: Text(
                  loc.tr('ads_no_items'),
                  style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16.sp),
                ),
              );
            }
            return ListView.separated(
              itemCount: ads.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (_, i) => AdCard(ad: ads[i]),
            );
          },
        ),
      ),
    );
  }
}
