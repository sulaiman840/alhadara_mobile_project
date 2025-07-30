import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
