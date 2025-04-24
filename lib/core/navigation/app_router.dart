import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/features/auth/presentation/screens/reset_password_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/screens/forgot_password_page.dart';
import '../../features/auth/presentation/screens/initial_survey_page.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/auth/presentation/screens/verify_code_page.dart';
import '../../features/counter/cubit/counter_cubit.dart';
import '../../features/counter/presentation/screens/counter_page.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../injection.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return BlocProvider<CounterCubit>(
            create: (_) => getIt<CounterCubit>()..loadCounter(),
            child: const CounterPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.SplashScreen,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutesNames.OnboardingScreen,
        builder: (_, __) => const OnboardingScreen(),
      ),

      GoRoute(
        path: AppRoutesNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutesNames.forgotPassword,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutesNames.verifyCodePage,
        builder: (_, __) => const VerifyCodePage(),
      ),
      GoRoute(
        path: AppRoutesNames.resetPassword,
        builder: (_, __) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: AppRoutesNames.initialSurvey,
        builder: (context, state) => const InitialSurveyPage(),
      ),
    ],
  );
}
