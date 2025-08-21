import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/TextFormField/custom_password_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/loading_overlay.dart';

import '../../cubit/reset_password_cubit.dart';
import '../../cubit/reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  // Keep cells as-is (direction/flow unchanged)
  final List<TextEditingController> _codeControllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _codeFocusNodes = List.generate(5, (_) => FocusNode());

  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  @override
  void dispose() {
    for (final c in _codeControllers) c.dispose();
    for (final f in _codeFocusNodes) f.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? v) {
    final loc = AppLocalizations.of(context);
    if (v == null || v.isEmpty) return loc.tr('login_error_field_required');
    return null;
  }

  String? _validateMatch(String? v) {
    final loc = AppLocalizations.of(context);
    if (v == null || v.isEmpty) return loc.tr('login_error_field_required');
    if (v != _newPwController.text) return loc.tr('passwords_not_match');
    return null;
  }

  void _submit() {
    final loc = AppLocalizations.of(context);
    final rawCode = _codeControllers.map((c) => c.text).join();
    if (rawCode.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.tr('verify_fill_all_digits')),
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.95),
        ),
      );
      return;
    }

    final reversed = rawCode.split('').reversed.join();
    final token = int.tryParse(reversed);
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.tr('verify_invalid_code')),
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.95),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    context.read<ResetPasswordCubit>().resetPassword(
      token: token,
      password: _newPwController.text.trim(),
      passwordConfirmation: _confirmPwController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: theme.textTheme.bodyMedium),
              backgroundColor: AppColor.green,
            ),
          );
          GoRouter.of(context).go(AppRoutesNames.login);
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage, style: theme.textTheme.bodyMedium),
              backgroundColor:  AppColor.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ResetPasswordLoading;

        return Scaffold(
          appBar: CustomAppBar(
            title: loc.tr('reset_title'),
            onBack: () => GoRouter.of(context).go(AppRoutesNames.forgotPassword),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                LayoutBuilder(
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

                              // Helper: code instructions
                              Text(
                                loc.tr('verify_hint'),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge,
                              ),
                              SizedBox(height: 8.h),

                              // === CODE CELLS (kept exactly as provided) ===
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
                                          // keep to match your original cells
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
                                              // keep your accent color choice
                                              color: Theme.of(context).colorScheme.primary,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (v) {
                                          // keep original flow
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

                              // Helper: create new password
                              Text(
                                loc.tr('reset_hint_create'),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge,
                              ),
                              SizedBox(height: 30.h),

                              CustomPasswordFormField(
                                controller: _newPwController,
                                hintText: loc.tr('password_hint_new'),
                                validator: _validateNotEmpty,
                              ),
                              SizedBox(height: 16.h),

                              CustomPasswordFormField(
                                controller: _confirmPwController,
                                hintText: loc.tr('password_hint_confirm'),
                                validator: _validateMatch,
                              ),
                              SizedBox(height: 40.h),

                              CustomButton(
                                text: isLoading ? loc.tr('resetting') : loc.tr('reset_button'),
                                onPressed: isLoading ? null : _submit,
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

                if (isLoading)
                  LoadingOverlay(message: loc.tr('reset_loading_message')),
              ],
            ),
          ),
        );
      },
    );
  }
}
