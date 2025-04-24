import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/TextFormField/custom_password_field.dart';
import '../../../../shared/widgets/TextFormField/custom_text_form_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/or_divider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey            = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(v)) return 'بريد إلكتروني غير صالح';
    return null;
  }

  String? _validateNotEmpty(String? v) =>
      (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: call your login API
      FocusScope.of(context).unfocus();
      GoRouter.of(context).go(AppRoutesNames.initialSurvey);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: 'تسجيل دخول',
          onBack: () => context.go(AppRoutesNames.OnboardingScreen),
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

                        // Email
                        CustomTextFormField(
                          controller: _emailController,
                          hintText: 'البريد الإلكتروني',
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 16.h),

                        // Password
                        CustomPasswordFormField(
                          controller: _passwordController,
                          hintText: 'كلمة المرور',
                          validator: _validateNotEmpty,
                        ),
                        SizedBox(height: 8.h),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {       GoRouter.of(context).go(AppRoutesNames.forgotPassword);
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(color: AppColor.purple, fontSize: 14.sp),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Login
                        CustomButton(text: 'تسجيل دخول', onPressed: _submit),
                        SizedBox(height: 12.h),

                        // Guest
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // GoRouter.of(context).go(AppRoutesNames.home);
                            },
                            child: Text(
                              'قم بتسجيل الدخول كزائر',
                              style: TextStyle(
                                color: AppColor.textDarkBlue,
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        const OrDivider(),
                        SizedBox(height: 16.h),

                        // Google
                        OutlinedButton.icon(
                          onPressed: () { /* TODO */ },
                          icon: FaIcon(FontAwesomeIcons.google, color: AppColor.purple, size: 20.r),
                          label: Text(
                            'تسجيل بواسطة جوجل',
                            style: TextStyle(color: AppColor.textDarkBlue, fontSize: 16.sp),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: BorderSide(color: AppColor.purple),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                          ),
                        ),

                        // push Google button to bottom
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
