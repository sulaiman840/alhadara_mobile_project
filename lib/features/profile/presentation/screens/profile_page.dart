import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../profile/cubit/profile_cubit.dart';
import '../../../profile/cubit/profile_state.dart';
import '../Widget/info_card_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: loc.tr('profile_title'),
        onBack: () => context.go(AppRoutesNames.home),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.colorScheme.primary),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is ProfileLoaded) {
            final p = state.profile;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 56.r,
                    backgroundColor:
                    theme.colorScheme.primary.withOpacity(0.12),
                    backgroundImage: (p.photo != null && p.photo.isNotEmpty)
                        ? NetworkImage('${ConstString.baseURl}${p.photo}')
                        : null,
                    child: (p.photo == null || p.photo.isEmpty)
                        ? Icon(Icons.person,
                        size: 40.r, color: theme.colorScheme.primary)
                        : null,
                  ),
                  SizedBox(height: 16.h),

                  // Name
                  Text(
                    p.name,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),

                  // Email
                  Text(
                    p.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),

                  // Info rows
                  InfoCardWidget(
                    icon: Icons.phone,
                    label: loc.tr('profile_phone'),
                    value: p.phone,
                  ),
                  InfoCardWidget(
                    icon: Icons.cake,
                    label: loc.tr('profile_birthday'),
                    value: p.birthday, // keep as-is (format provided by API)
                  ),
                  InfoCardWidget(
                    icon: Icons.person,
                    label: loc.tr('profile_gender'),
                    value: (p.gender?.toLowerCase() == 'male')
                        ? loc.tr('gender_male')
                        : loc.tr('gender_female'),
                  ),
                  InfoCardWidget(
                    icon: Icons.star,
                    label: loc.tr('profile_points'),
                    value: p.points.toString(),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
