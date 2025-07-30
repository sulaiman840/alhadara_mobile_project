import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/shared/widgets/bottom_nav_bar.dart';
import 'package:alhadara_mobile_project/features/home/cubit/points_cubit.dart';
import 'package:alhadara_mobile_project/features/home/cubit/departments_cubit.dart';
import 'package:alhadara_mobile_project/features/my_course_details/cubit/my_courses_cubit.dart';
import 'package:alhadara_mobile_project/features/auth/cubit/login_cubit.dart';
import 'package:alhadara_mobile_project/features/auth/cubit/forgot_password_cubit.dart';
import 'package:alhadara_mobile_project/features/auth/cubit/verify_cubit.dart';
import 'package:alhadara_mobile_project/features/auth/cubit/reset_password_cubit.dart';
import 'package:alhadara_mobile_project/features/calendar/cubit/schedule_cubit.dart';
import 'package:alhadara_mobile_project/features/trainers/cubit/trainers_cubit.dart';
import 'package:alhadara_mobile_project/features/trainers/presentation/screens/trainers_page.dart';
import 'package:alhadara_mobile_project/features/home/presentation/screens/home_page.dart';
import 'package:alhadara_mobile_project/features/calendar/presentation/screens/weekly_activity_page.dart';
import 'package:alhadara_mobile_project/features/my_course_details/presentation/screens/my_course_details_page.dart';
import 'package:alhadara_mobile_project/features/course_details/presentation/screens/course_details_page.dart';
import 'package:alhadara_mobile_project/features/course_sections/presentation/screens/course_sections_page.dart';
import 'package:alhadara_mobile_project/features/forum/presentation/screens/forum_page.dart';
import 'package:alhadara_mobile_project/features/forum/presentation/screens/forum_detail_page.dart';
import 'package:alhadara_mobile_project/features/notifications/presentation/screens/notifications_page.dart';
import 'package:alhadara_mobile_project/features/profile/presentation/screens/profile_page.dart';
import 'package:alhadara_mobile_project/features/search/presentation/screens/course_search_page.dart';
import 'package:alhadara_mobile_project/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:alhadara_mobile_project/features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_page.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/auth/presentation/screens/reset_password_page.dart';
import '../../features/auth/presentation/screens/verify_code_page.dart';
import '../../features/course_sections/cubit/sections_cubit.dart';
import '../../features/forum/cubit/forum_cubit.dart';
import '../../features/home/cubit/courses_cubit.dart';
import '../../features/home/cubit/recommendations_cubit.dart';
import '../../features/home/data/models/course_model.dart';
import '../../features/home/presentation/screens/courses_list_page.dart';
import '../../features/home/presentation/screens/my_courses_page.dart';
import '../../features/menu_features/ads/cubit/ads_cubit.dart';
import '../../features/menu_features/ads/presentation/screens/active_ads_page.dart';
import '../../features/menu_features/complaints/cubit/complaints_cubit.dart';
import '../../features/menu_features/complaints/presentation/screens/complaints_page.dart';
import '../../features/menu_features/gifts/cubit/gifts_cubit.dart';
import '../../features/menu_features/gifts/presentation/screens/gifts_page.dart';
import '../../features/menu_features/menu/cubit/logout_cubit/logout_cubit.dart';
import '../../features/menu_features/menu/presentation/screens/menu_page.dart';
import '../../features/menu_features/settings/presentation/screens/language_selection_page.dart';
import '../../features/menu_features/settings/presentation/screens/settings_page.dart';
import '../../features/menu_features/settings/presentation/screens/theme_mode_selection_page.dart';
import '../../features/menu_features/test_results/cubit/grades_cubit.dart';
import '../../features/menu_features/test_results/presentation/screens/test_results_page.dart';
import '../../features/notifications/cubit/notifications_cubit.dart';
import '../../features/profile/cubit/profile_cubit.dart';
import '../../features/ratings/cubit/ratings_cubit.dart';
import '../../features/saved courses/cubit/saved_courses_cubit.dart';
import '../../features/saved courses/presentation/screens/saved_courses_page.dart';
import '../../features/search/cubit/search_cubit.dart';
import '../../features/trainers/data/models/trainer_with_course_model.dart';
import '../../features/trainers/presentation/screens/trainer_details_page.dart';
import '../injection.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutesNames.SplashScreen,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (outerContext, state, child) {
          final nestedLocation = state.uri.toString();

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<PointsCubit>()),
              BlocProvider.value(value: getIt<DepartmentsCubit>()),
              BlocProvider.value(value: getIt<MyCoursesCubit>()),
              BlocProvider.value(value: getIt<RecommendationsCubit>()),
            ],
            child: Builder(builder: (innerContext) {
              return Scaffold(
                body: child,
                bottomNavigationBar: MyBottomNavBar(
                  currentIndex: _calculateIndex(nestedLocation),
                  onTap: (i) => _onNavTap(innerContext, i),
                ),
              );
            }),
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
              child: BlocProvider<ScheduleCubit>(
                create: (_) {
                  final cubit = getIt<ScheduleCubit>();
                  const weekdays = [
                    'saturday',
                    'sunday',
                    'monday',
                    'tuesday',
                    'wednesday',
                    'thursday',
                    'friday'
                  ];
                  final slug = weekdays[DateTime.now().weekday % 7];
                  cubit.fetchByDay(slug);
                  return cubit;
                },
                child: const WeeklyActivityPage(),
              ),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.savedCourses,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider<SavedCoursesCubit>(
                create: (_) => getIt<SavedCoursesCubit>()..fetchSaved(),
                child: const SavedCoursesPage(),
              ),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.trainers,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider<TrainersCubit>(
                create: (_) => getIt<TrainersCubit>()..fetchAll(),
                child: const TrainersPage(),
              ),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.menu_page,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider<LogoutCubit>(
                create: (_) => getIt<LogoutCubit>(),
                child: const MenuPage(),
              ),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
          GoRoute(
            path: AppRoutesNames.search,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider<SearchCubit>(
                create: (_) => getIt<SearchCubit>(),
                child: const CourseSearchPage(),
              ),
              transitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          ),
        ],
      ),

      GoRoute(
          path: AppRoutesNames.SplashScreen,
          builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: AppRoutesNames.OnboardingScreen,
          builder: (_, __) => const OnboardingPage()),

      GoRoute(
        path: AppRoutesNames.login,
        builder: (ctx, state) => BlocProvider<LoginCubit>(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesNames.forgotPassword,
        builder: (ctx, state) => BlocProvider<ForgotPasswordCubit>(
          create: (_) => getIt<ForgotPasswordCubit>(),
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesNames.verifyCodePage,
        builder: (ctx, state) => BlocProvider<VerifyCubit>(
          create: (_) => getIt<VerifyCubit>(),
          child: const VerifyCodePage(),
        ),
      ),
      GoRoute(
        path: AppRoutesNames.resetPassword,
        builder: (ctx, state) => BlocProvider<ResetPasswordCubit>(
          create: (_) => getIt<ResetPasswordCubit>(),
          child: const ResetPasswordPage(),
        ),
      ),

      GoRoute(
        path: AppRoutesNames.myCourses,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<MyCoursesCubit>(
                  create: (_) => getIt<MyCoursesCubit>()..fetchMyCourses()),
              BlocProvider<SavedCoursesCubit>(
                  create: (_) => getIt<SavedCoursesCubit>()..fetchSaved()),
            ],
            child: const MyCoursesPage(),
          ),
          transitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        ),
      ),

      GoRoute(
        name: 'myCourseDetails',
        path: AppRoutesNames.myCourseDetails,
        pageBuilder: (ctx, state) {
          final sectionId = int.parse(state.pathParameters['enrolledId']!);
          return CustomTransitionPage(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<MyCoursesCubit>(
                  create: (_) => getIt<MyCoursesCubit>()..fetchMyCourses(),
                ),
                BlocProvider<RatingsCubit>(
                  create: (_) =>
                      getIt<RatingsCubit>()..loadSectionRatings(sectionId),
                ),
              ],
              child: MyCourseDetailsPage(enrolledId: sectionId),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

      GoRoute(
        path: AppRoutesNames.coursesList,
        pageBuilder: (ctx, state) {
          final args = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<CoursesCubit>(
                    create: (_) =>
                        getIt<CoursesCubit>()..fetchCourses(args['id'] as int)),
                BlocProvider<SavedCoursesCubit>(
                    create: (_) => getIt<SavedCoursesCubit>()..fetchSaved()),
              ],
              child: CoursesListPage(
                departmentId: args['id'] as int,
                departmentName: args['name'] as String,
              ),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

      GoRoute(
        name: 'courseDetails',
        path: AppRoutesNames.courseDetails,
        pageBuilder: (ctx, state) {
          final data = state.extra as Map<String, dynamic>;
          final course =
              CourseModel.fromJson(data['course'] as Map<String, dynamic>);
          return CustomTransitionPage(
            key: state.pageKey,
            child: CourseDetailsPage(
                course: course, deptName: data['deptName'] as String),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

      GoRoute(
        path: AppRoutesNames.pendingSections,
        pageBuilder: (ctx, state) {
          final data = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider<SectionsCubit>(
              create: (_) => getIt<SectionsCubit>()
                ..fetchSections((data['course'] as CourseModel).id),
              child: SectionsPage(
                course: data['course'] as CourseModel,
                deptName: data['deptName'] as String,
              ),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

      GoRoute(
        name: 'forum',
        path: AppRoutesNames.forum,
        pageBuilder: (ctx, state) {
          final sectionId = int.parse(state.pathParameters['sectionId']!);
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, anim, __, child) {
              return SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(anim),
                child: child,
              );
            },
            child: BlocProvider<ForumCubit>(
              create: (_) => getIt<ForumCubit>()..loadQuestions(sectionId),
              child: ForumPage(sectionId: sectionId),
            ),
          );
        },
      ),

      GoRoute(
        name: 'forumDetail',
        path: AppRoutesNames.forumDetail,
        pageBuilder: (ctx, state) {
          final sId = int.parse(state.pathParameters['sectionId']!);
          final qId = int.parse(state.pathParameters['questionId']!);
          return CustomTransitionPage(
            key: state.pageKey,
            opaque: true,
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
            child: BlocProvider.value(
              value: getIt<ForumCubit>()..loadQuestions(sId),
              child: ForumDetailPage(sectionId: sId, questionId: qId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.activeAds,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<AdsCubit>(
            create: (_) => getIt<AdsCubit>()..fetchActiveAds(),
            child: const ActiveAdsPage(),
          ),
          transitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        ),
      ),
      GoRoute(
          path: AppRoutesNames.search,
          builder: (_, __) => const CourseSearchPage()),
      GoRoute(
        path: AppRoutesNames.notifications,
        builder: (ctx, state) => BlocProvider(
          create: (_) => getIt<NotificationsCubit>()..fetchNotifications(),
          child: const NotificationsPage(),
        ),
      ),

      GoRoute(
        path: AppRoutesNames.profile,
        builder: (ctx, state) => BlocProvider<ProfileCubit>(
          create: (_) => getIt<ProfileCubit>()..fetchProfile(),
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
          path: AppRoutesNames.settings, builder: (_, __) => const SettingsPage()),
      GoRoute(
          path: AppRoutesNames.language,
          builder: (_, __) => const LanguageSelectionPage()),
      GoRoute(
          path: AppRoutesNames.themeMode,
          builder: (_, __) => const ThemeModeSelectionPage()),

      GoRoute(
        path: AppRoutesNames.testResults,
        builder: (ctx, state) => BlocProvider<GradesCubit>(
          create: (_) => getIt<GradesCubit>()..fetchGrades(),
          child: const TestResultsPage(),
        ),
      ),

      GoRoute(
        path: AppRoutesNames.gifts,
        builder: (ctx, state) => BlocProvider<GiftsCubit>(
          create: (_) => getIt<GiftsCubit>()..loadGifts(),
          child: const GiftsPage(),
        ),
      ),

      GoRoute(
        path: AppRoutesNames.complaints,
        builder: (ctx, state) => BlocProvider<ComplaintsCubit>(
          create: (_) => getIt<ComplaintsCubit>(),
          child: const ComplaintsPage(),
        ),
      ),

      GoRoute(
        path: AppRoutesNames.trainersDetails,
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          final trainer =
              Trainer.fromJson(args['trainer'] as Map<String, dynamic>);
          final courses = (args['courses'] as List)
              .cast<Map<String, dynamic>>()
              .map((m) => Course.fromJson(m))
              .toList();
          return TrainerDetailsPage(
            trainer: trainer,
            courses: courses,
          );
        },
      ),

    ],
  );

  static int _calculateIndex(String loc) {
    switch (loc) {
      case AppRoutesNames.home:
        return 0;
      case AppRoutesNames.activity:
        return 1;
      case AppRoutesNames.savedCourses:
        return 2;
      case AppRoutesNames.trainers:
        return 3;
      case AppRoutesNames.menu_page:
        return 4;
      default:
        return 0;
    }
  }

  static void _onNavTap(BuildContext ctx, int tabIndex) {
    final goRouter = GoRouter.of(ctx);

    final currentLoc = goRouter
        .routeInformationProvider
        .value
        .uri
        .path;

    final target = _tabIndexToPath(tabIndex);

    String normalize(String p) =>
        p.endsWith('/') && p.length > 1 ? p.substring(0, p.length - 1) : p;

    if (normalize(currentLoc) == normalize(target)) {
      if (tabIndex == 0) {
        ctx.read<PointsCubit>().loadPoints();
        ctx.read<DepartmentsCubit>().fetchDepartments();
        ctx.read<MyCoursesCubit>().fetchMyCourses();
      }
      return;
    }


    goRouter.go(target);
  }

  static String _tabIndexToPath(int i) {
    switch (i) {
      case 0:
        return AppRoutesNames.home;
      case 1:
        return AppRoutesNames.activity;
      case 2:
        return AppRoutesNames.savedCourses;
      case 3:
        return AppRoutesNames.trainers;
      case 4:
        return AppRoutesNames.menu_page;
      default:
        return AppRoutesNames.home;
    }
  }
}

