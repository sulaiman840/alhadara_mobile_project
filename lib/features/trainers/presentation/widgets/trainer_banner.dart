import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerBanner extends StatelessWidget {
  final String photoUrl;
  const TrainerBanner({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      expandedHeight: 250.h,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: photoUrl.startsWith('http')
            ? Image.network(photoUrl, fit: BoxFit.contain)
            : Image.asset(photoUrl, fit: BoxFit.contain),
      ),
    );
  }
}
