import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection.dart';
import '../../../../core/network/firebase_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';
import '../../../../shared/widgets/loading_overlay.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _firebaseService = getIt<FirebaseService>();

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();


    final fcmToken = await _firebaseService.getToken() ?? '';


    print('$fcmToken');
    BlocProvider.of<LoginCubit>(context).login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
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
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                GoRouter.of(context).go(AppRoutesNames.home);
              } else if (state is LoginUnverified) {
                GoRouter.of(context).go(AppRoutesNames.verifyCodePage);
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    children: [
                      SizedBox(height: 30.h),

                      CustomTextFormField(
                        controller: _emailController,
                        hintText: 'البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 16.h),

                      CustomPasswordFormField(
                        controller: _passwordController,
                        hintText: 'كلمة المرور',
                        validator: _validateNotEmpty,
                      ),
                      SizedBox(height: 8.h),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            GoRouter.of(context)
                                .go(AppRoutesNames.forgotPassword);
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: AppColor.purple,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            BlocBuilder<LoginCubit, LoginState>(
                              builder: (context, currentState) {
                                return CustomButton(
                                  text: currentState is LoginLoading
                                      ? 'جارٍ تسجيل الدخول...'
                                      : 'تسجيل دخول',
                                  onPressed: currentState is LoginLoading
                                      ? null
                                      : _submit,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Guest login link
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

                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: implement Google sign‐in
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.google,
                          color: AppColor.purple,
                          size: 20.r,
                        ),
                        label: Text(
                          'تسجيل بواسطة جوجل',
                          style: TextStyle(
                            color: AppColor.textDarkBlue,
                            fontSize: 16.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: AppColor.purple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                      ),

                      SizedBox(height: 100.h),
                    ],
                  ),
                  if (state is LoginLoading)
                    const LoadingOverlay(
                      message: 'جارٍ تسجيل الدخول...',
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
