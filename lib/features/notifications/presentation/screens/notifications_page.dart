import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../../core/utils/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/notifications_cubit.dart';
import '../../cubit/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  String _formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(title: 'الإشعارات'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.purple,
                  ),
                );
              }

              if (state is NotificationsError) {
                return Center(
                  child: Text(state.message, style: TextStyle(color: AppColor.red)),
                );
              }

              if (state is NotificationsLoaded) {
                final notes = state.notifications;
                if (notes.isEmpty) {
                  return const Center(child: Text('لا توجد إشعارات'));
                }

                return RefreshIndicator(
                  color: AppColor.purple,
                  onRefresh: cubit.fetchNotifications,
                  child: ListView.separated(
                    separatorBuilder: (_, __) => Divider(
                      color: AppColor.gray2,
                      thickness: 0.5.h,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (ctx, idx) {
                      final n = notes[idx];
                      final isUnread = !n.isRead;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Card(
                          color: isUnread ? AppColor.white : AppColor.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.r),
                            onTap: () {
                              // TODO: mark as read / navigate
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: AppColor.purple2.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications,
                                      color: AppColor.purple,
                                      size: 24.r,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          n.title,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.textDarkBlue,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          n.body,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColor.textDarkBlue,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          _formatTime(n.createdAt),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color:AppColor.textDarkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
