import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/TextFormField/custom_password_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPwController     = TextEditingController();
  final _confirmPwController = TextEditingController();

  @override
  void dispose() {
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? v) {
    if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  String? _validateMatch(String? v) {
    if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
    if (v != _newPwController.text) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      // TODO: call your "reset password" API with _newPwController.text
      // then maybe navigate to login:
      GoRouter.of(context).go(AppRoutesNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'كلمة مرور جديدة',
          onBack: () => GoRouter.of(context).go(AppRoutesNames.verifyCodePage),
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
                          'قم بإنشاء كلمة مرور جديدة لتسجيل الدخول',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.textDarkBlue,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // New password
                        CustomPasswordFormField(
                          controller: _newPwController,
                          hintText: 'كلمة المرور',
                          validator: _validateNotEmpty,
                        ),
                        SizedBox(height: 16.h),

                        // Confirm password
                        CustomPasswordFormField(
                          controller: _confirmPwController,
                          hintText: 'تأكيد كلمة المرور',
                          validator: _validateMatch,
                        ),
                        SizedBox(height: 40.h),

                        // Submit
                        CustomButton(
                          text: 'إنشاء كلمة مرور جديدة',
                          onPressed: _submit,
                        ),

                        // Push up if keyboard appears
                        const Spacer(),
                        SizedBox(height: 16.h),
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
