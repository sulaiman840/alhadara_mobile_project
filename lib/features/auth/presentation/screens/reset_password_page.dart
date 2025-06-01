// lib/features/auth/presentation/screens/reset_password_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/TextFormField/custom_password_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/loading_overlay.dart';

import '../../cubit/reset_password_cubit.dart';
import '../../cubit/reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  // Five controllers & focus nodes for the 5‐digit verification code
  final List<TextEditingController> _codeControllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _codeFocusNodes = List.generate(5, (_) => FocusNode());

  final TextEditingController _newPwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  @override
  void dispose() {
    for (final c in _codeControllers) c.dispose();
    for (final f in _codeFocusNodes) f.dispose();
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
    final rawCode = _codeControllers.map((c) => c.text).join();
    if (rawCode.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال جميع أرقام الرمز')),
      );
      return;
    }
    final reversed = rawCode.split('').reversed.join();
    final token = int.tryParse(reversed);
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرمز غير صالح')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newPw = _newPwController.text.trim();
    final confirmPw = _confirmPwController.text.trim();
    FocusScope.of(context).unfocus();
    context.read<ResetPasswordCubit>().resetPassword(
      token: token,
      password: newPw,
      passwordConfirmation: confirmPw,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          // optionally show a loading overlay (handled below)
        }
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          GoRouter.of(context).go(AppRoutesNames.login);
        }
        if (state is ResetPasswordFailure) {
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
              title: 'كلمة مرور جديدة',
              onBack: () =>
                  GoRouter.of(context).go(AppRoutesNames.forgotPassword),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (ctx, constraints) => SingleChildScrollView(
                      padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 30.h),

                                // ─────────────────────── Verification Code Input ───────────────────────
                                Text(
                                  'أدخل الرمز المكون من 5 أرقام الذي أرسلناه إلى بريدك الإلكتروني',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.textDarkBlue,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (i) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                                        width: 50.w,
                                        height: 50.w,
                                        child: TextField(
                                          controller: _codeControllers[i],
                                          focusNode: _codeFocusNodes[i],
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          style: TextStyle(
                                            color: AppColor.textDarkBlue,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.r),
                                              borderSide: BorderSide(
                                                color: AppColor.purple,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          onChanged: (v) {
                                            if (v.length == 1) {
                                              if (i > 0) {
                                                _codeFocusNodes[i - 1].requestFocus();
                                              } else {
                                                _codeFocusNodes[i].unfocus();
                                              }
                                            }
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                SizedBox(height: 30.h),

                                // ─────────────────────── New Password Fields ───────────────────────
                                Text(
                                  'قم بإنشاء كلمة مرور جديدة لتسجيل الدخول',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.textDarkBlue,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 30.h),

                                CustomPasswordFormField(
                                  controller: _newPwController,
                                  hintText: 'كلمة المرور',
                                  validator: _validateNotEmpty,
                                ),
                                SizedBox(height: 16.h),

                                CustomPasswordFormField(
                                  controller: _confirmPwController,
                                  hintText: 'تأكيد كلمة المرور',
                                  validator: _validateMatch,
                                ),
                                SizedBox(height: 40.h),

                                CustomButton(
                                  text: state is ResetPasswordLoading
                                      ? 'جاري إعادة التعيين...'
                                      : 'إنشاء كلمة مرور جديدة',
                                  onPressed:
                                  state is ResetPasswordLoading ? null : _submit,
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

                  // Full‐screen “loading” overlay while reset is in progress
                  if (state is ResetPasswordLoading)
                    const LoadingOverlay(
                        message: 'جارٍ إعادة تعيين كلمة المرور...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
