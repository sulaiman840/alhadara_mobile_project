// lib/features/auth/ui/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';

import '../../../../shared/widgets/TextFormField/custom_text_form_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'الرجاء إدخال رقم هاتفك';
    }
    // you can add a more sophisticated regex here if you like
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: call your "send verification code" API, then:
      FocusScope.of(context).unfocus();
      GoRouter.of(context).go(AppRoutesNames.verifyCodePage);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'نسيت كلمة المرور',
          onBack: () => context.go(AppRoutesNames.login),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, constraints) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 30.h),

                        // Subtitle
                        Text(
                          'لا تقلق، ما عليك سوى كتابة رقم هاتفك\nوسنرسل رمز التحقق',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.textDarkBlue,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 30.h),

                        CustomTextFormField(
                          controller: _phoneController,
                          hintText: '911 101 923 963+',
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                        ),
                        SizedBox(height: 24.h),

                        // Send button
                        CustomButton(
                          text: 'نسيت كلمة المرور',
                          onPressed: _submit,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
