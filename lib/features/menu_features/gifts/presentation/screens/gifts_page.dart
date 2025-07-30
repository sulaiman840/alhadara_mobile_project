import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/gifts_cubit.dart';
import '../../cubit/gifts_state.dart';
import '../widgets/gift_card.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: loc.tr('gifts_title'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: BlocBuilder<GiftsCubit, GiftsState>(
          builder: (context, state) {
            if (state is GiftsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GiftsFailure) {
              return Center(
                child: Text(
                  loc.tr('gifts_error'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.red, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              );
            }
            final gifts = state is GiftsSuccess ? state.gifts : [];
            if (gifts.isEmpty) {
              return Center(
                child: Text(
                  loc.tr('gifts_no_items'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 16.sp),
                ),
              );
            }
            return ListView.separated(
              itemCount: gifts.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (_, i) => GiftCard(gift: gifts[i]),
            );
          },
        ),
      ),
    );
  }
}
