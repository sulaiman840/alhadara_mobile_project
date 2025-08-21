import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';

import '../../../../shared/widgets/TextFormField/custom_text_form_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';

import '../../cubit/forgot_password_cubit.dart';
import '../../cubit/forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final loc = AppLocalizations.of(context);
    if (v == null || v.isEmpty) return loc.tr('login_error_enter_email');
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(v)) return loc.tr('login_error_invalid_email');
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<ForgotPasswordCubit>().forgotPassword(
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: theme.textTheme.bodyMedium),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.9),
            ),
          );
          context.push(AppRoutesNames.resetPassword);
        } else if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage, style: theme.textTheme.bodyMedium),
              backgroundColor: theme.colorScheme.error.withOpacity(0.95),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;

        return Scaffold(

          appBar: CustomAppBar(
            title: loc.tr('login_forgot_password'),

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

                          // Helper text (localized + themed)
                          Text(
                            loc.tr('forgot_password_hint'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),

                          SizedBox(height: 30.h),

                          // Email
                          CustomTextFormField(
                            controller: _emailController,
                            hintText: loc.tr('login_hint_email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),

                          SizedBox(height: 24.h),

                          // Submit
                          CustomButton(
                            text: isLoading ? loc.tr('sending') : loc.tr('send'),
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
          ),
        );
      },
    );
  }
}
