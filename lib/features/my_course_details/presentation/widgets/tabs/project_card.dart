import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectCard extends StatelessWidget {
  final String imagePath;
  const ProjectCard(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.asset(imagePath, height: 140.h, fit: BoxFit.cover),
    );
  }
}
