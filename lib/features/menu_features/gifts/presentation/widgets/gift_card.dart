import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import '../../data/models/gift_model.dart';

class GiftCard extends StatelessWidget {
  final GiftModel gift;
  const GiftCard({required this.gift, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPhoto = gift.photo?.isNotEmpty == true;
    final imageUrl =
    hasPhoto ? '${ConstString.baseURl}${gift.photo}' : null;
    final date = DateTime.tryParse(gift.date);
    final dateLabel = date != null
        ? '${date.day}/${date.month}/${date.year}'
        : gift.date;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
                errorBuilder: (_, __, ___) => Container(
                  height: 150.h,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.broken_image,
                    size: 40.r,
                    color: theme
                        .colorScheme.onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 150.h,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                            (progress.expectedTotalBytes ?? 1)
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
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.gift,
                    size: 33.r,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  gift.description,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 70.w),
            child: Text(
              dateLabel,
              style: theme.textTheme.bodySmall!
                  .copyWith(
                fontSize: 12.sp,
                color: theme
                    .colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
