
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/TextFormField/custom_text_form_field.dart';
import '../../../../shared/widgets/TextFormField/custom_password_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtl;
  late TextEditingController _passwordCtl;
  late TextEditingController _phoneCtl;

  @override
  void initState() {
    super.initState();

    _nameCtl     = TextEditingController(text: 'أحمد محمد');
    _passwordCtl = TextEditingController(text: 'password123');
    _phoneCtl    = TextEditingController(text: '911 101 923 963+');
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _passwordCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // TODO: submit updated profile
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التغييرات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'تعديل الملف الشخصي',
          onBack: () => context.go(AppRoutesNames.home),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar with edit overlay
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundImage: AssetImage('assets/images/man.png'),
                    ),
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: AppColor.purple,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.r),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18.r,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _nameCtl,
                      hintText: 'الاسم الكامل',
                      validator: (v) =>
                      (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
                    ),
                    SizedBox(height: 16.h),

                    CustomPasswordFormField(
                      controller: _passwordCtl,
                      hintText: 'كلمة المرور',
                      validator: (v) =>
                      (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
                    ),
                    SizedBox(height: 16.h),

                    CustomTextFormField(
                      controller: _phoneCtl,
                      hintText: 'رقم الجوال',
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                      (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              CustomButton(
                text: 'حفظ التغييرات',
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
