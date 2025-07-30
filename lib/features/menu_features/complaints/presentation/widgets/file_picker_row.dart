import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

class FilePickerRow extends StatelessWidget {
  const FilePickerRow({
    super.key,
    this.selectedFile,
    required this.onPick,
  });

  final File? selectedFile;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: onPick,
          icon: Icon(Icons.attach_file, size: 20.r, color: theme.colorScheme.onPrimary),
          label: Text(
            loc.tr('attach_file'),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            selectedFile != null
                ? selectedFile!.path.split('/').last
                : loc.tr('no_file_selected'),
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
