// lib/core/navigation/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/shared/widgets/bottom_nav_bar.dart';

import '../../features/complaints/presentation/screens/complaints_page.dart';
import '../../features/finished courses/presentation/screens/finished_courses_page.dart';
import '../../features/gifts/presentation/screens/gifts_page.dart';
import '../../features/languages/presentation/screens/language_selection_page.dart';
import '../../features/menu/presentation/screens/menu_page.dart';
import '../../features/notifications/presentation/screens/notifications_page.dart';
import '../../features/profile/presentation/screens/profile_page.dart';
import '../../features/saved courses/presentation/screens/saved_courses_page.dart';
import '../../features/search/presentation/screens/course_search_page.dart';
import '../../features/settings/presentation/screens/settings_page.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/auth/presentation/screens/forgot_password_page.dart';
import '../../features/auth/presentation/screens/verify_code_page.dart';
import '../../features/auth/presentation/screens/reset_password_page.dart';
import '../../features/auth/presentation/screens/initial_survey_page.dart';
import '../../features/home/presentation/screens/home_page.dart';
import '../../features/calendar/presentation/screens/weekly_activity_page.dart';
import '../../features/calendar/presentation/screens/calendar_page.dart';
import '../../features/home/presentation/screens/my_courses_page.dart';
import '../../features/home/presentation/screens/courses_list_page.dart';
import '../../features/my_course_details/presentation/screens/my_course_details_page.dart';
import '../../features/course_details/presentation/screens/course_details_page.dart';
import '../../features/forum/presentation/screens/forum_page.dart';
import '../../features/forum/presentation/screens/forum_detail_page.dart';
import '../../features/test_results/presentation/screens/test_results_page.dart';
import '../../features/theme_mode/presentation/screens/theme_mode_selection_page.dart';
import '../../features/trainers/presentation/screens/trainer_details_page.dart';
import '../../features/trainers/presentation/screens/trainers_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutesNames.SplashScreen,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final loc = state.uri.toString();
          int idx;
          switch (loc) {
            case AppRoutesNames.home:
              idx = 0;
              break;
            case AppRoutesNames.activity:
              idx = 1;
              break;
            case AppRoutesNames.savedCourses:
              idx = 2;
              break;
            case AppRoutesNames.trainers:
              idx = 3;
              break;
            case AppRoutesNames.menu_page:
              idx = 4;
              break;
            default:
              idx = 0;
          }
          return Scaffold(
            body: child,
            bottomNavigationBar: MyBottomNavBar(
              currentIndex: idx,
              onTap: (i) {
                switch (i) {
                  case 0:
                    context.go(AppRoutesNames.home);
                    break;
                  case 1:
                    context.go(AppRoutesNames.activity);
                    break;
                  case 2:
                    context.go(AppRoutesNames.savedCourses);
                    break;
                  case 3:
                    context.go(AppRoutesNames.trainers);
                    break;
                  case 4:
                    context.go(AppRoutesNames.menu_page);
                    break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutesNames.home,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.activity,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const WeeklyActivityPage(),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.savedCourses,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SavedCoursesPage(),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.trainers,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const TrainersPage(),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.menu_page,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const MenuPage(),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),


        ],
      ),

      // GoRoute(
      //   path: '/home',
      //   builder: (context, state) {
      //     return BlocProvider<CounterCubit>(
      //       create: (_) => getIt<CounterCubit>()..loadCounter(),
      //       child: const CounterPage(),
      //     );
      //   },
      // ),
      GoRoute(
        path: AppRoutesNames.calendar,
        builder: (context, state) => const CalendarPage(),
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
      // GoRoute(
      //   path: AppRoutesNames.home,
      //   builder: (context, state) => const HomePage(),
      // ),


      // GoRoute(
      //   path: '${AppRoutesNames.categories}/:label',
      //   // builder: (context, state) {
      //   //   final label = state.pathParameters['label']!;
      //   //   return CategoryCoursesPage(categoryLabel: label);
      //   // },
      // ),

      GoRoute(
        path: AppRoutesNames.myCourses,
        builder: (context, state) => const MyCoursesPage(),
      ),
      GoRoute(
        path: AppRoutesNames.coursesList,
        builder: (context, state) => const CoursesListPage(),
      ),
      GoRoute(
        path: AppRoutesNames.myCourseDetails,
        builder: (context, state) => const MyCourseDetailsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.courseDetails,
        builder: (context, state) => const CourseDetailsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.fourm,
        builder: (context, state) => const ForumPage(),
      ),
      GoRoute(
        path: AppRoutesNames.fourmDetail,
        builder: (context, state) {
          final post = state.extra as Post;
          return ForumDetailPage(post);
        },
      ),

      GoRoute(
        path: AppRoutesNames.search,
        builder: (_, __) => const CourseSearchPage(),
      ),
      GoRoute(
        path: AppRoutesNames.notifications,
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.profile,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutesNames.settings,
        builder: (_, __) => const Settings(),
      ),
      GoRoute(
        path: AppRoutesNames.language,
        builder: (_, __) => const LanguageSelectionPage(),
      ),
      GoRoute(
        path: AppRoutesNames.themeMode,
        builder: (_, __) => const ThemeModeSelectionPage(),
      ),
      GoRoute(
        path: AppRoutesNames.finishedCourses,
        builder: (_, __) => const FinishedCoursesPage(),
      ),
      GoRoute(
        path: AppRoutesNames.testResults,
        builder: (_, __) => const TestResultsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.gifts,
        builder: (_, __) => const GiftsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.complaints,
        builder: (_, __) => const ComplaintsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.trainersDetails,
        builder: (_, __) =>  TrainerDetailsPage(),
      ),
    ],
  );
}


