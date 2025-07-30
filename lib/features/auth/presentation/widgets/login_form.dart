import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/TextFormField/custom_text_form_field.dart';
import '../../../../shared/widgets/TextFormField/custom_password_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../widgets/login_social.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.isLoading,
  });

  String? _validateEmail(BuildContext c, String? v) {
    final loc = AppLocalizations.of(c);
    if (v == null || v.isEmpty) {
      return loc.tr('login_error_enter_email');
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(v)) {
      return loc.tr('login_error_invalid_email');
    }
    return null;
  }

  String? _validateNotEmpty(BuildContext c, String? v) {
    final loc = AppLocalizations.of(c);
    return (v == null || v.isEmpty)
        ? loc.tr('login_error_field_required')
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final loc   = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      children: [
        SizedBox(height: 30.h),

        CustomTextFormField(
          controller: emailController,
          hintText: loc.tr('login_hint_email'),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => _validateEmail(context, v),
        ),
        SizedBox(height: 16.h),

        CustomPasswordFormField(
          controller: passwordController,
          hintText: loc.tr('login_hint_password'),
          validator: (v) => _validateNotEmpty(context, v),
        ),
        SizedBox(height: 8.h),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => GoRouter.of(context).go(AppRoutesNames.forgotPassword),
            child: Text(
              loc.tr('login_forgot_password'),
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.primary, fontSize: 14.sp),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        Form(
          key: formKey,
          child: CustomButton(
            text: isLoading
                ? loc.tr('login_button_loading')
                : loc.tr('login_button'),
            onPressed: isLoading ? null : onSubmit,
          ),
        ),
        SizedBox(height: 12.h),

        Center(
          child: TextButton(
            onPressed: () { },
            child: Text(
              loc.tr('login_guest'),
              style: theme.textTheme.bodySmall!
                  .copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // — Social
        LoginSocial(),
      ],
    );
  }
}
