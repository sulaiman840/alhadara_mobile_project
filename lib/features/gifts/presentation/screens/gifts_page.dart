
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/injection.dart';
import '../../../../core/utils/const.dart';
import '../../data/models/gift_model.dart';
import '../../cubit/gifts_cubit.dart';
import '../../cubit/gifts_state.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GiftsCubit>(
      create: (_) {
        final cubit = getIt<GiftsCubit>();
        cubit.loadGifts();
        return cubit;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColor.background,
          appBar: CustomAppBar(
            title: 'الهدايا',

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
                      state.errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (state is GiftsSuccess) {
                  final gifts = state.gifts;

                  if (gifts.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد هدايا حتى الآن',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.textDarkBlue,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: gifts.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (ctx, idx) {
                      final gift = gifts[idx];
                      final date = DateTime.tryParse(gift.date);
                      final dateLabel = date == null
                          ? gift.date
                          : '${date.day}/${date.month}/${date.year}';

                      return GiftCard(
                        gift: gift,
                        dateLabel: dateLabel,
                        icon: FontAwesomeIcons.gift,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GiftCard extends StatelessWidget {
  final GiftModel gift;
  final String dateLabel;
  final IconData icon;

  const GiftCard({
    required this.gift,
    required this.dateLabel,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasPhoto = gift.photo != null && gift.photo!.isNotEmpty;
    final imageUrl = hasPhoto
        ? '${ConstString.baseURl}${gift.photo}'
        : null;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasPhoto) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                imageUrl!,
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => Container(
                  height: 150.h,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.broken_image,
                    size: 40.r,
                    color: AppColor.gray3,
                  ),
                ),
                loadingBuilder: (ctx, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150.h,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),
          ],

          Row(
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: AppColor.purple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(icon, size: 33.r, color: AppColor.purple),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  gift.description,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDarkBlue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          Row(
            children: [
              SizedBox(width: 70.w),
              Expanded(
                child: Text(
                  dateLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.gray3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
