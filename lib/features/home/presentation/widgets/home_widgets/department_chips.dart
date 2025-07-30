import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/navigation/routes_names.dart';
import '../../../cubit/departments_cubit.dart';
import '../../../cubit/departments_state.dart';

class DepartmentChips extends StatelessWidget {
  const DepartmentChips({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
      builder: (context, state) {
        if (state is DepartmentsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DepartmentsFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (state is DepartmentsSuccess) {
          final list = state.departments;
          if (list.isEmpty) {
            return Center(
              child: Text(
                loc.tr('no_department_so_far'),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }
          return SizedBox(
            height: 80.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, i) {
                final dep = list[i];
                final imageUrl = dep.photo.startsWith('http')
                    ? dep.photo
                    : '${ConstString.baseURl}${dep.photo}';
                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutesNames.coursesList,
                      extra: {'id': dep.id, 'name': dep.name},
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Image.network(
                          imageUrl,
                          width: 55.r,
                          height: 48.r,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48.r,
                            height: 48.r,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.broken_image,
                              size: 24.r,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 48.r,
                              height: 48.r,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          (progress.expectedTotalBytes!)
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          dep.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
