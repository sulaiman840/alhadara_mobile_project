import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  // we’ll keep four controllers & focus nodes
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // gather the code
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال جميع أرقام الرمز')),
      );
      return;
    }
    GoRouter.of(context).go(AppRoutesNames.resetPassword);

    // TODO: call your "verify code" API with `code`
  }

  void _onResend() {
    // TODO: call your "resend code" API
  }

  @override
  Widget build(BuildContext context) {
    // your email – ideally passed in via constructor or state
    const email = 'jarxxxxx@email.com';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'التحقق من الرمز',
          onBack: () => context.go(AppRoutesNames.forgotPassword),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, constraints) => SingleChildScrollView(
              padding:
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: ConstrainedBox(
                constraints:
                BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 30.h),

                      // subtitle
                      Text(
                        'أدخل الرمز الذي أرسلناه إلى عنوان بريدك التالي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.textDarkBlue,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // email line
                      Text(
                        email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.textDarkBlue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // the 4 boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (i) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            width: 60.w,
                            height: 60.w,
                            child: TextField(
                              controller: _controllers[i],
                              focusNode: _focusNodes[i],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(color: AppColor.textDarkBlue,
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
                                      color: AppColor.purple, width: 2),
                                ),
                              ),
                              onChanged: (v) {
                                if (v.length == 1) {
                                  if (i < 3) {
                                    _focusNodes[i + 1].requestFocus();
                                  } else {
                                    _focusNodes[i].unfocus();
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 40.h),

                      // verify button
                      CustomButton(
                        text: 'تحقق من الرمز',
                        onPressed: _onSubmit,
                      ),
                      SizedBox(height: 12.h),

                      // resend link
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

                      // pushes everything up if keyboard appears
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
    );
  }
}
