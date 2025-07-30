import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/ad_model.dart';
import 'ad_content.dart';
import 'ad_image.dart';

class AdCard extends StatelessWidget {
  final AdModel ad;
  const AdCard({required this.ad, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (ad.photo != null && ad.photo!.isNotEmpty)
            AdImage(photoPath: ad.photo!),
          AdContent(
            title: ad.title,
            description: ad.description,
            startDate: ad.startDate,
            endDate: ad.endDate,
          ),
        ],
      ),
    );
  }
}