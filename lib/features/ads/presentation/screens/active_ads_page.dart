// lib/features/ads/presentation/screens/active_ads_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../ads/cubit/ads_cubit.dart';
import '../../../ads/cubit/ads_state.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/const.dart';

class ActiveAdsPage extends StatefulWidget {
  const ActiveAdsPage({Key? key}) : super(key: key);

  @override
  _ActiveAdsPageState createState() => _ActiveAdsPageState();
}

class _ActiveAdsPageState extends State<ActiveAdsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdsCubit>().fetchActiveAds();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: const Text('الإعلانات'),
          backgroundColor: AppColor.purple,
          elevation: 0,
        ),
        body: BlocBuilder<AdsCubit, AdsState>(
          builder: (ctx, state) {
            if (state is AdsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AdsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: AppColor.textDarkBlue,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }
            if (state is AdsLoaded) {
              final ads = state.page.ads;
              if (ads.isEmpty) {
                return const Center(child: Text('لا توجد إعلانات نشطة'));
              }

              String fmt(DateTime d) =>
                  '${d.toLocal().year}-${d.toLocal().month.toString().padLeft(2, '0')}-${d.toLocal().day.toString().padLeft(2, '0')}';

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: ads.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (_, i) {
                  final ad = ads[i];
                  final imageUrl = ad.photo?.isNotEmpty == true
                      ? '${ConstString.baseURl}/storage/${ad.photo}'
                      : null;

                  return Card(
                    color: AppColor.purple,
                    elevation: 4,
                    shadowColor: AppColor.purple.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // only show image if we have a valid URL
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.r)),
                            child: Image.network(
                              imageUrl,
                              height: 160.h,
                              fit: BoxFit.cover,
                              loadingBuilder: (ctx, child, prog) {
                                if (prog == null) return child;
                                return Container(
                                  height: 160.h,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: prog.expectedTotalBytes != null
                                          ? prog.cumulativeBytesLoaded /
                                          prog.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                height: 160.h,
                                color: Colors.grey[200],
                                child: Icon(Icons.broken_image,
                                    size: 48.r, color: AppColor.gray3),
                              ),
                            ),
                          ),

                        // text content
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad.title,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                ad.description,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColor.gray,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 14.r, color: AppColor.gray),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${fmt(ad.startDate)} → ${fmt(ad.endDate)}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
