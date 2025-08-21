import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar_title.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/loading_overlay.dart';

import '../../cubit/verify_cubit.dart';
import '../../cubit/verify_state.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  // Keep cells (count/flow) exactly as you had them
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
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final rawCode = _controllers.map((c) => c.text).join();
    if (rawCode.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.tr('verify_fill_all_digits'),
              style: theme.textTheme.bodyMedium),
          backgroundColor: theme.colorScheme.error.withOpacity(0.95),
        ),
      );
      return;
    }

    // Keep your reverse-then-parse logic intact
    final reversedCode = rawCode.split('').reversed.join();
    final token = int.tryParse(reversedCode);
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(loc.tr('verify_invalid_code'), style: theme.textTheme.bodyMedium),
          backgroundColor: theme.colorScheme.error.withOpacity(0.95),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<VerifyCubit>().verifyAccount(token: token);
  }

  void _onResend() {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // If you later add a resend endpoint, call cubit here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.tr('resend_code'), style: theme.textTheme.bodyMedium),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<VerifyCubit, VerifyState>(
      listener: (context, state) {
        if (state is VerifySuccess) {
          // Prefer localized success message; fall back to backend message
          final msg = state.message.trim().toLowerCase().contains('verified')
              ? loc.tr('verify_account_verified')
              : state.message;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg, style: theme.textTheme.bodyMedium),
              backgroundColor: AppColor.green,
            ),
          );
          GoRouter.of(context).go(AppRoutesNames.login);
        } else if (state is VerifyFailure) {
          final lower = state.errorMessage.trim().toLowerCase();
          String err = state.errorMessage;
          if (lower.contains('invalid code')) {
            err = loc.tr('verify_invalid_code');
          } else if (lower.contains('not verified')) {
            err = loc.tr('verify_account_not_verified');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err, style: theme.textTheme.bodyMedium),
              backgroundColor: AppColor.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is VerifyLoading;

        return Scaffold(
          appBar: CustomAppBarTitle(
            title: loc.tr('verify_title'),
            onBack: () => context.go(AppRoutesNames.login),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                LayoutBuilder(
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

                            // Helper text
                            Text(
                              loc.tr('verify_hint'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                            SizedBox(height: 8.h),

                            // === OTP CELLS (kept as-is: RTL row + LTR digits + same focus flow) ===
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (i) {
                                  return Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 6.w),
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
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12.r),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12.r),
                                          borderSide: BorderSide(
                                            color: theme.colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      onChanged: (v) {
                                        // Keep original flow behavior
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

                            CustomButton(
                              text:
                              isLoading ? loc.tr('verifying') : loc.tr('verify_button'),
                              onPressed: isLoading ? null : _onSubmit,
                            ),


                            const Spacer(),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (isLoading)
                  LoadingOverlay(message: loc.tr('verify_loading_message')),
              ],
            ),
          ),
        );
      },
    );
  }
}
