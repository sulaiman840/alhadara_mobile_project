import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/notifications_cubit.dart';
import '../../cubit/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  String _formatTime(BuildContext context, DateTime dt) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('HH:mm', locale).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cubit = context.read<NotificationsCubit>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(title: loc.tr('notifications_title')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
            }

            if (state is NotificationsError) {
              return Center(
                child: Text(
                  state.message.isNotEmpty ? state.message : loc.tr('notifications_error'),
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (state is NotificationsLoaded) {
              final notes = state.notifications;
              if (notes.isEmpty) {
                return Center(
                  child: Text(
                    loc.tr('notifications_empty'),
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return RefreshIndicator(
                color: theme.colorScheme.primary,
                onRefresh: cubit.fetchNotifications,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => Divider(
                    height: 5.h,
                    thickness: 0.6.h,
                    color: theme.colorScheme.onSurface.withOpacity(0.08),
                  ),
                  itemCount: notes.length,
                  itemBuilder: (ctx, idx) {
                    final n = notes[idx];


                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Card(
                        color: theme.cardColor,
                        elevation: 2,
                        shadowColor: theme.colorScheme.onSurface.withOpacity(0.06),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: ()  {

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
                                    color: theme.colorScheme.primary.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.notifications, size: 22.r, color: theme.colorScheme.primary),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              n.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.titleMedium,
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      // Full body (no truncation)
                                      Text(
                                        n.body,
                                        style: theme.textTheme.bodyMedium,
                                        softWrap: true,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        _formatTime(context, n.createdAt),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface.withOpacity(0.6),
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
    );
  }
}
