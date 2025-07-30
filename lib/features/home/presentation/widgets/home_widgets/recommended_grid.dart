import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../cubit/recommendations_cubit.dart';
import '../../../cubit/recommendations_state.dart';

class RecommendedGrid extends StatelessWidget {
  const RecommendedGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<RecommendationsCubit, RecommendationsState>(
      builder: (context, state) {
        if (state is RecommendationsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RecommendationsFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14.sp,
              ),
            ),
          );
        }
        if (state is RecommendationsSuccess) {
          final courses = state.courses;
          if (courses.isEmpty) {
            return Center(
              child: Text(
                loc.tr('no_recommend_course_for_now'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, i) {
              final c = courses[i];
              final imageUrl = c.photo.isNotEmpty
                  ? (c.photo.startsWith('http')
                  ? c.photo
                  : '${ConstString.baseURl}${c.photo}')
                  : null;

              return GestureDetector(
                onTap: () {
                  context.pushNamed(
                    'courseDetails',
                    extra: {
                      'course': c.toJson(),
                      'deptName': '',
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: imageUrl != null
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.broken_image,
                            size: 48.r,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      c.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
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
    );
  }
}
