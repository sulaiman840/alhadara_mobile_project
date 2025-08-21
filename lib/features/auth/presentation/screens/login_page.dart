import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection.dart';
import '../../../../core/network/firebase_service.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../widgets/login_form.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey            = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseService    = getIt<FirebaseService>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fcmToken = await _firebaseService.getToken() ?? '';
    context.read<LoginCubit>().login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (ctx, state) {
          if (state is LoginSuccess) {
            GoRouter.of(ctx).go(AppRoutesNames.home);
          } else if (state is LoginUnverified) {
            GoRouter.of(ctx).go(AppRoutesNames.verifyCodePage);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (ctx, state) {
          final isLoading = state is LoginLoading;

          return Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                resizeToAvoidBottomInset: true,
                appBar: CustomAppBar(
                  title: loc.tr('login_title'),
                ),
                body: SafeArea(
                  child: LoginForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onSubmit: _submit,
                    isLoading: isLoading,
                  ),
                ),
              ),
              if (isLoading)
                LoadingOverlay(
                  message: loc.tr('login_button_loading'),
                ),
            ],
          );
        },
      ),
    );
  }
}
