// lib/features/auth/presentation/screens/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../../../shared/widgets/TextFormField/custom_text_form_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

import '../../cubit/forgot_password_cubit.dart';
import '../../cubit/forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(v)) return 'بريد إلكتروني غير صالح';
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final email = _emailController.text.trim();
      context.read<ForgotPasswordCubit>().forgotPassword(email: email);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          GoRouter.of(context).go(AppRoutesNames.resetPassword);
        }
        if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
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
                            Text(
                              'لا تقلق، ما عليك سوى إدخال بريدك الإلكتروني\nوسنرسل رمز التحقق',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColor.textDarkBlue,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            CustomTextFormField(
                              controller: _emailController,
                              hintText: 'البريد الإلكتروني',
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                            ),
                            SizedBox(height: 24.h),
                            CustomButton(
                              text: state is ForgotPasswordLoading
                                  ? 'جاري الإرسال...'
                                  : 'التأكيد',
                              onPressed:
                              state is ForgotPasswordLoading ? null : _submit,
                            ),
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
      },
    );
  }
}