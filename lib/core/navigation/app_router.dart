import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/navigation/routes_names.dart';
import 'package:alhadara_mobile_project/shared/widgets/bottom_nav_bar.dart';

import '../../features/auth/cubit/forgot_password_cubit.dart';
import '../../features/auth/cubit/login_cubit.dart';
import '../../features/auth/cubit/reset_password_cubit.dart';
import '../../features/auth/cubit/verify_cubit.dart';
import '../../features/calendar/cubit/schedule_cubit.dart';
import '../../features/complaints/cubit/complaints_cubit.dart';
import '../../features/complaints/presentation/screens/complaints_page.dart';
import '../../features/course_details/presentation/screens/test_details_page.dart';
import '../../features/course_sections/cubit/sections_cubit.dart';
import '../../features/course_sections/data/datasources/sections_remote_data_source.dart';
import '../../features/course_sections/data/repositories/sections_repository.dart';
import '../../features/course_sections/presentation/screens/course_sections_page.dart';
import '../../features/finished courses/presentation/screens/finished_courses_page.dart';
import '../../features/forum/cubit/forum_cubit.dart';
import '../../features/gifts/cubit/gifts_cubit.dart';
import '../../features/gifts/presentation/screens/gifts_page.dart';
import '../../features/home/cubit/courses_cubit.dart';
import '../../features/home/cubit/departments_cubit.dart';
import '../../features/home/cubit/points_cubit.dart';
import '../../features/home/data/models/course_model.dart';
import '../../features/languages/presentation/screens/language_selection_page.dart';
import '../../features/menu/cubit/logout_cubit/logout_cubit.dart';
import '../../features/menu/presentation/screens/menu_page.dart';
import '../../features/my_course_details/cubit/my_courses_cubit.dart';
import '../../features/my_course_details/data/models/enrolled_course_model.dart';
import '../../features/my_course_details/presentation/screens/my_test_details_page.dart';
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
import '../../features/home/presentation/screens/my_courses_page.dart';
import '../../features/home/presentation/screens/courses_list_page.dart';
import '../../features/my_course_details/presentation/screens/my_course_details_page.dart';
import '../../features/course_details/presentation/screens/course_details_page.dart';
import '../../features/forum/presentation/screens/forum_page.dart';
import '../../features/forum/presentation/screens/forum_detail_page.dart';
import '../../features/test_results/cubit/grades_cubit.dart';
import '../../features/test_results/presentation/screens/test_results_page.dart';
import '../../features/theme_mode/presentation/screens/theme_mode_selection_page.dart';
import '../../features/trainers/cubit/trainers_cubit.dart';
import '../../features/trainers/data/models/trainer_with_course_model.dart';
import '../../features/trainers/presentation/screens/trainer_details_page.dart';
import '../../features/trainers/presentation/screens/trainers_page.dart';
import '../injection.dart';
import '../network/dio_client.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutesNames.SplashScreen,
    debugLogDiagnostics: true,
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
            pageBuilder: (ctx, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<PointsCubit>(
                      create: (_) => getIt<PointsCubit>()..loadPoints(),
                    ),
                    BlocProvider<DepartmentsCubit>(
                      create: (_) =>
                          getIt<DepartmentsCubit>()..fetchDepartments(),
                    ),
                    BlocProvider<MyCoursesCubit>(
                      create: (_) => getIt<MyCoursesCubit>()..fetchMyCourses(),
                    ),
                    // If HomePage also needs GiftsCubit for “recent gifts” or something:
                  ],
                  child: const HomePage(),
                ),
                transitionDuration: Duration.zero,
                transitionsBuilder: (_, __, ___, child) => child,
              );
            },
          ),
          GoRoute(
            path: AppRoutesNames.activity,
            pageBuilder: (ctx, state) => CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider<ScheduleCubit>(
                create: (_) {
                  final cubit = getIt<ScheduleCubit>();
                  // initial fetch for today
                  const List<String> _weekDaySlugs = [
                    'saturday',
                    'sunday',
                    'monday',
                    'tuesday',
                    'wednesday',
                    'thursday',
                    'friday',
                  ];

                  final todaySlug = _weekDaySlugs[DateTime.now().weekday % 7];
                  cubit.fetchByDay(todaySlug);
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
              child: const SavedCoursesPage(),
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
        path: AppRoutesNames.SplashScreen,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutesNames.OnboardingScreen,
        builder: (_, __) => const OnboardingScreen(),
      ),

      GoRoute(
        path: AppRoutesNames.login,
        builder: (context, state) {
          return BlocProvider<LoginCubit>(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.forgotPassword,
        builder: (context, state) {
          return BlocProvider<ForgotPasswordCubit>(
            create: (_) => getIt<ForgotPasswordCubit>(),
            child: const ForgotPasswordPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.verifyCodePage,
        builder: (context, state) {
          return BlocProvider<VerifyCubit>(
            create: (_) => getIt<VerifyCubit>(),
            child: const VerifyCodePage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.resetPassword,
        builder: (context, state) {
          return BlocProvider<ResetPasswordCubit>(
            create: (_) => getIt<ResetPasswordCubit>(),
            child: const ResetPasswordPage(),
          );
        },
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
        pageBuilder: (context, state) {
          // Make sure MyCoursesPage has its own MyCoursesCubit as well:
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider<MyCoursesCubit>(
              create: (_) => getIt<MyCoursesCubit>()..fetchMyCourses(),
              child: const MyCoursesPage(),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.myCourseDetails,
        pageBuilder: (context, state) {
          // we expect `extra` to be an EnrolledCourseModel:
          final enrolled = state.extra as EnrolledCourseModel;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MyCourseDetailsPage(enrolled: enrolled),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

      GoRoute(
        path: AppRoutesNames.coursesList,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final int deptId = args['id'] as int;
          final String deptName = args['name'] as String;

          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider<CoursesCubit>(
              create: (_) => getIt<CoursesCubit>()..fetchCourses(deptId),
              child: CoursesListPage(
                departmentId: deptId,
                departmentName: deptName,
              ),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

      GoRoute(
        path: AppRoutesNames.courseDetails,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final course = args['course'] as CourseModel;
          final deptName = args['deptName'] as String;

          return CustomTransitionPage(
            key: state.pageKey,
            child: CourseDetailsPage(
              course: course,
              deptName: deptName,
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

      GoRoute(
        path: AppRoutesNames.pendingSections,
        pageBuilder: (context, state) {
          // We expect that “extra” is a Map<String, dynamic> containing:
          //   'course': CourseModel
          //   'deptName': String
          final args = state.extra as Map<String, dynamic>;
          final course = args['course'] as CourseModel;
          final deptName = args['deptName'] as String;

          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider<SectionsCubit>(
              create: (_) => getIt<SectionsCubit>()..fetchSections(course.id),
              child: SectionsPage(
                course: course,
                deptName: deptName,
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
            child: BlocProvider<ForumCubit>(
              create: (_) {
                final c = getIt<ForumCubit>();
                c.loadQuestions(sectionId);
                return c;
              },
              child: ForumPage(sectionId: sectionId),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
        },
      ),

// Forum detail
      GoRoute(
        name: 'forumDetail',
        path: AppRoutesNames.forumDetail,
        pageBuilder: (ctx, state) {
          final sectionId  = int.parse(state.pathParameters['sectionId']!);
          final questionId = int.parse(state.pathParameters['questionId']!);
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider.value(
              value: getIt<ForumCubit>()..loadQuestions(sectionId),
              child: ForumDetailPage(
                sectionId: sectionId,
                questionId: questionId,
              ),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          );
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
        builder: (context, state) {
          return BlocProvider<GradesCubit>(
            create: (_) => getIt<GradesCubit>()..fetchGrades(),
            child: const TestResultsPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.gifts,
        builder: (context, state) {
          return BlocProvider<GiftsCubit>(
            create: (_) => getIt<GiftsCubit>()..loadGifts(),
            child: const GiftsPage(),
          );
        },
      ),

      GoRoute(
        path: AppRoutesNames.complaints,
        builder: (context, state) {
          return BlocProvider<ComplaintsCubit>(
            create: (_) => getIt<ComplaintsCubit>(),
            child: const ComplaintsPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.trainersDetails,
        builder: (_, state) {
          final trainerWithCourse = state.extra as TrainerWithCourse;
          return TrainerDetailsPage(trainerWithCourse: trainerWithCourse);
        },
      ),
      GoRoute(
        path: AppRoutesNames.testDetails,
        builder: (_, __) => TestDetailsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.myTestDetails,
        builder: (_, __) => MyTestDetailsPage(),
      )
    ],
  );
}
