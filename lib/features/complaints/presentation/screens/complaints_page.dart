
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart'; // <-- for optional file picking
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../cubit/complaints_cubit.dart';
import '../../cubit/complaints_state.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final TextEditingController _controller = TextEditingController();
  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
      });
    }
  }

  void _sendComplaint() {
    final text = _controller.text.trim();
    context.read<ComplaintsCubit>().submitComplaint(
      description: text,
      file: _selectedFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComplaintsCubit, ComplaintsState>(
      listener: (context, state) {
        if (state is ComplaintsSuccess) {
          _controller.clear();
          setState(() => _selectedFile = null);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // content: Text(state.response.message),
              content: Text("تم ارسال الشكوى بنجاح"),

              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is ComplaintsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColor.background,
          appBar: CustomAppBar(
            title: 'المساعدة والدعم الفني',
            onBack: () => context.go(AppRoutesNames.menu_page),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Complaint TextField ────────────────────────
                TextField(
                  controller: _controller,   style: TextStyle(
                  color: AppColor.textDarkBlue,
                  fontSize: 16.sp,
                ),
                  maxLines: 3,cursorColor:AppColor.textDarkBlue,
                  decoration: InputDecoration(
                    hintText: 'اكتب شكوى او استفسارك هنا (على الأقل 10 أحرف)',
                    hintStyle: TextStyle(color: AppColor.gray3),
                    filled: true,
                    fillColor: AppColor.white,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // ─── Optional File Picker ──────────────────────
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: Icon(Icons.attach_file, size: 20.r,color: AppColor.white,),
                      label: Text(
                        'إرفاق ملف (اختياري)',
                        style: TextStyle(fontSize: 14.sp,color: AppColor.white,),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _selectedFile == null
                            ? 'لم يتم اختيار ملف'
                            : _selectedFile!.path.split('/').last,
                        style: TextStyle(color: AppColor.textDarkBlue, fontSize: 14.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // ─── Send Button ────────────────────────────────
                BlocBuilder<ComplaintsCubit, ComplaintsState>(
                  builder: (context, state) {
                    final isLoading = state is ComplaintsLoading;
                    return SizedBox(
                      height: 48.h,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _sendComplaint,
                        icon: isLoading
                            ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Icon(Icons.send, size: 20.r,color: AppColor.white,),
                        label: Text(
                          isLoading ? 'جاري الإرسال...' : 'إرسال',
                          style: TextStyle(
                            fontSize: 16.sp,color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
