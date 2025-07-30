import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:alhadara_mobile_project/shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../cubit/complaints_cubit.dart';
import '../../cubit/complaints_state.dart';
import '../widgets/complaint_input.dart';
import '../widgets/file_picker_row.dart';
import '../widgets/send_complaint_button.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final _textController = TextEditingController();
  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        setState(() => _selectedFile = File(path));
      }
    }
  }

  void _send() {
    context.read<ComplaintsCubit>().submitComplaint(
      description: _textController.text.trim(),
      file: _selectedFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocListener<ComplaintsCubit, ComplaintsState>(
      listener: (ctx, state) {
        if (state is ComplaintsSuccess) {
          _textController.clear();
          setState(() => _selectedFile = null);
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(loc.tr('complaint_success')),
              backgroundColor: AppColor.green,
            ),
          );
        }
        if (state is ComplaintsFailure) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(loc.tr(state.errorMessage)),
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: loc.tr('complaints_title'),
          onBack: () => context.pop(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ComplaintInput(controller: _textController),
              SizedBox(height: 16.h),
              FilePickerRow(
                selectedFile: _selectedFile,
                onPick: _pickFile,
              ),
              SizedBox(height: 24.h),
              BlocBuilder<ComplaintsCubit, ComplaintsState>(
                builder: (ctx, state) {
                  final isLoading = state is ComplaintsLoading;
                  return SendComplaintButton(
                    loading: isLoading,
                    onPressed: isLoading ? null : _send,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
