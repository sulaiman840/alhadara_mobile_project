import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'الملف الشخصي',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            if (state is ProfileLoaded) {
              final p = state.profile;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(
                        '${ConstString.baseURl}${p.photo}',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      p.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textDarkBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      p.email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textDarkBlue.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    InfoCardWidget(
                      icon: Icons.phone,
                      label: 'رقم الجوال',
                      value: p.phone,
                    ),
                    InfoCardWidget(
                      icon: Icons.cake,
                      label: 'تاريخ الميلاد',
                      value: p.birthday,
                    ),
                    InfoCardWidget(
                      icon: Icons.person,
                      label: 'الجنس',
                      value: p.gender == 'male' ? 'ذكر' : 'أنثى',
                    ),
                    InfoCardWidget(
                      icon: Icons.star,
                      label: 'النقاط',
                      value: p.points.toString(),
                    ),
                  ],
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

