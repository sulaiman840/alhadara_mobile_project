
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final TextEditingController _controller = TextEditingController();

  void _sendComplaint() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة شكوى أو استفسار')),
      );
      return;
    }
    // TODO: handle sending...
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال شكواك بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
              // The decorated input field
              TextField(
                controller: _controller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'اكتب شكوى او استفسارك هنا',
                  hintStyle: TextStyle(color: AppColor.gray3),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),

                  // arrow on the left (suffix in RTL)
                  suffixIcon: Icon(
                    Icons.chevron_left,
                    color: AppColor.gray3,
                    size: 24.r,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Send button
              SizedBox(
                height: 48.h,
                child: ElevatedButton.icon(
                  onPressed: _sendComplaint,
                  icon: Icon(Icons.send, size: 20.r),
                  label: Text(
                    'إرسال',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
