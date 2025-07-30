import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../cubit/verify_cubit.dart';
import '../../cubit/verify_state.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/loading_overlay.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _controllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final rawCode = _controllers.map((c) => c.text).join();
    if (rawCode.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال جميع أرقام الرمز')),
      );
      return;
    }
    final reversedCode = rawCode.split('').reversed.join();
    final token = int.tryParse(reversedCode);
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرمز غير صالح')),
      );
      return;
    }
    context.read<VerifyCubit>().verifyAccount(token: token);
  }

  void _onResend() {
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyCubit, VerifyState>(
      listener: (context, state) {
        if (state is VerifySuccess) {
          final msgLower = state.message.trim().toLowerCase();
          String displayMsg;
          if (msgLower == 'your account has been verified') {
            displayMsg = 'تم التحقق من حسابك بنجاح';
          } else {
            displayMsg = state.message;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(displayMsg)),
          );
          GoRouter.of(context).go(AppRoutesNames.login);
        }

        if (state is VerifyFailure) {
          final errLower = state.errorMessage.trim().toLowerCase();
          String displayErr;
          if (errLower.contains('invalid code')) {
            displayErr = 'الرمز غير صالح';
          } else if (errLower.contains('account not verified')) {
            displayErr = 'الحساب غير مُفعّل بعد';
          } else {
            displayErr = state.errorMessage;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(displayErr)),
          );
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColor.background,
            appBar: CustomAppBar(
              title: 'التحقق من الرمز',
              onBack: () => context.go(AppRoutesNames.login),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  ListView(
                    padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    children: [
                      SizedBox(height: 30.h),
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
                                controller: _controllers[i],
                                focusNode: _focusNodes[i],
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
                                      _focusNodes[i - 1].requestFocus();
                                    } else {
                                      _focusNodes[i].unfocus();
                                    }
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      BlocBuilder<VerifyCubit, VerifyState>(
                        builder: (context, verifyState) {
                          return CustomButton(
                            text: verifyState is VerifyLoading
                                ? 'جارٍ التحقق...'
                                : 'تحقق من الرمز',
                            onPressed: verifyState is VerifyLoading
                                ? null
                                : _onSubmit,
                          );
                        },
                      ),
                      SizedBox(height: 12.h),

                      Center(
                        child: TextButton(
                          onPressed: _onResend,
                          child: Text(
                            'إعادة إرسال الرمز',
                            style: TextStyle(
                              color: AppColor.purple,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 100.h),
                    ],
                  ),

                  if (state is VerifyLoading)
                    const LoadingOverlay(
                      message: 'جارٍ التحقق من الرمز...',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
