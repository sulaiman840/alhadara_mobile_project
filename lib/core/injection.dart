import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/cubit/forgot_password_cubit.dart';
import '../features/auth/cubit/login_cubit.dart';
import '../features/auth/cubit/reset_password_cubit.dart';
import '../features/auth/cubit/verify_cubit.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/calendar/cubit/schedule_cubit.dart';
import '../features/calendar/data/datasources/schedule_remote_data_source.dart';
import '../features/calendar/data/repositories/schedule_repository.dart';
import '../features/course_sections/cubit/sections_cubit.dart';
import '../features/course_sections/data/datasources/sections_remote_data_source.dart';
import '../features/course_sections/data/repositories/sections_repository.dart';
import '../features/forum/cubit/forum_cubit.dart';
import '../features/forum/data/datasources/forum_remote_data_source.dart';
import '../features/forum/data/repositories/forum_repository.dart';
import '../features/home/cubit/courses_cubit.dart';
import '../features/home/cubit/departments_cubit.dart';
import '../features/home/cubit/points_cubit.dart';
import '../features/home/cubit/recommendations_cubit.dart';
import '../features/home/data/datasources/courses_remote_data_source.dart';
import '../features/home/data/datasources/departments_remote_data_source.dart';
import '../features/home/data/datasources/points_remote_data_source.dart';
import '../features/home/data/datasources/recommendations_remote_data_source.dart';
import '../features/home/data/repositories/courses_repository.dart';
import '../features/home/data/repositories/departments_repository.dart';
import '../features/home/data/repositories/points_repository.dart';
import '../features/home/data/repositories/recommendations_repository.dart';
import '../features/menu_features/ads/cubit/ads_cubit.dart';
import '../features/menu_features/ads/data/datasources/ads_remote_data_source.dart';
import '../features/menu_features/ads/data/repositories/ads_repository.dart';
import '../features/menu_features/complaints/cubit/complaints_cubit.dart';
import '../features/menu_features/complaints/data/datasources/complaints_remote_data_source.dart';
import '../features/menu_features/complaints/data/repositories/complaints_repository.dart';
import '../features/menu_features/gifts/cubit/gifts_cubit.dart';
import '../features/menu_features/gifts/data/datasources/gifts_remote_data_source.dart';
import '../features/menu_features/gifts/data/repositories/gifts_repository.dart';
import '../features/menu_features/menu/cubit/logout_cubit/logout_cubit.dart';
import '../features/menu_features/test_results/cubit/grades_cubit.dart';
import '../features/menu_features/test_results/data/datasources/grades_remote_data_source.dart';
import '../features/menu_features/test_results/data/repositories/grades_repository.dart';
import '../features/my_course_details/cubit/my_courses_cubit.dart';
import '../features/my_course_details/cubit/quiz_cubit.dart';
import '../features/my_course_details/cubit/section_files_cubit.dart';
import '../features/my_course_details/data/datasources/my_courses_remote_data_source.dart';
import '../features/my_course_details/data/datasources/quiz_remote_data_source.dart';
import '../features/my_course_details/data/datasources/section_files_remote_data_source.dart';
import '../features/my_course_details/data/repositories/my_courses_repository.dart';
import '../features/my_course_details/data/repositories/quiz_repository.dart';
import '../features/my_course_details/data/repositories/section_files_repository.dart';
import '../features/notifications/cubit/notifications_cubit.dart';
import '../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../features/notifications/data/repositories/notifications_repository.dart';
import '../features/profile/cubit/profile_cubit.dart';
import '../features/profile/data/datasources/profile_remote_data_source.dart';
import '../features/profile/data/repositories/profile_repository.dart';
import '../features/ratings/cubit/ratings_cubit.dart';
import '../features/ratings/data/datasources/ratings_remote_data_source.dart';
import '../features/ratings/data/repositories/ratings_repository.dart';
import '../features/saved courses/cubit/saved_courses_cubit.dart';
import '../features/saved courses/data/datasources/saved_courses_remote_data_source.dart';
import '../features/saved courses/data/repositories/saved_courses_repository.dart';
import '../features/search/cubit/search_cubit.dart';
import '../features/search/data/datasources/search_remote_data_source.dart';
import '../features/search/data/repositories/search_repository.dart';
import '../features/trainers/cubit/trainers_cubit.dart';
import '../features/trainers/data/datasources/trainers_remote_data_source.dart';
import '../features/trainers/data/repositories/trainers_repository.dart';
import 'network/api_service.dart';
import 'network/dio_client.dart';
import 'network/firebase_service.dart';
import 'network/notification_service.dart';

final GetIt getIt = GetIt.instance;


Future<void> initialServices() async {
  await configureDependencies();
}

Future<void> configureDependencies() async {
  getIt.registerLazySingleton(() => DioClient());
  getIt.registerLazySingleton(() => ApiService());



  getIt.registerLazySingleton<Dio>(
        () => getIt<DioClient>().dio,
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepository(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerFactory<LoginCubit>(
        () => LoginCubit(getIt<AuthRepository>()),
  );
  getIt.registerFactory<VerifyCubit>(
        () => VerifyCubit(getIt<AuthRepository>()),
  );

  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt<AuthRepository>()));
  getIt.registerFactory<ForgotPasswordCubit>(
        () => ForgotPasswordCubit(getIt<AuthRepository>()),
  );
  getIt.registerFactory<ResetPasswordCubit>(
        () => ResetPasswordCubit(getIt<AuthRepository>()),
  );
/////////////////////////////
  getIt.registerLazySingleton<GradesRemoteDataSource>(
        () => GradesRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<GradesRepository>(
        () => GradesRepository(getIt<GradesRemoteDataSource>()),
  );

  getIt.registerFactory<GradesCubit>(
        () => GradesCubit(getIt<GradesRepository>()),
  );
/////////////////////////
  getIt.registerLazySingleton<GiftsRemoteDataSource>(
        () => GiftsRemoteDataSourceImpl(getIt<Dio>()),
  );

  getIt.registerLazySingleton<GiftsRepository>(
        () => GiftsRepositoryImpl(getIt<GiftsRemoteDataSource>()),
  );

  getIt.registerFactory<GiftsCubit>(
        () => GiftsCubit(getIt<GiftsRepository>()),
  );
  //////////////////

  getIt.registerLazySingleton<PointsRemoteDataSource>(
        () => PointsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<PointsRepository>(
        () => PointsRepositoryImpl(getIt<PointsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<PointsCubit>(
        () => PointsCubit(getIt<PointsRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<ComplaintsRemoteDataSource>(
        () => ComplaintsRemoteDataSourceImpl(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ComplaintsRepository>(
        () => ComplaintsRepositoryImpl(getIt<ComplaintsRemoteDataSource>()),
  );

  getIt.registerFactory<ComplaintsCubit>(
        () => ComplaintsCubit(getIt<ComplaintsRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<DepartmentsRemoteDataSource>(
        () => DepartmentsRemoteDataSourceImpl(getIt<Dio>()),
  );

  getIt.registerLazySingleton<DepartmentsRepository>(
        () => DepartmentsRepositoryImpl(getIt<DepartmentsRemoteDataSource>()),
  );

  getIt.registerLazySingleton<DepartmentsCubit>(
        () => DepartmentsCubit(getIt<DepartmentsRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<CoursesRemoteDataSource>(
        () => CoursesRemoteDataSourceImpl(getIt<Dio>()),
  );

  getIt.registerLazySingleton<CoursesRepository>(
        () => CoursesRepositoryImpl(getIt<CoursesRemoteDataSource>()),
  );

  getIt.registerFactory<CoursesCubit>(
        () => CoursesCubit(getIt<CoursesRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<SectionsRemoteDataSource>(
        () => SectionsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<SectionsRepository>(
        () => SectionsRepositoryImpl(getIt<SectionsRemoteDataSource>()),
  );
  getIt.registerFactory<SectionsCubit>(
        () => SectionsCubit(getIt<SectionsRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<MyCoursesRemoteDataSource>(
        () => MyCoursesRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MyCoursesRepository>(
        () => MyCoursesRepositoryImpl(getIt<MyCoursesRemoteDataSource>()),
  );
  getIt.registerLazySingleton<MyCoursesCubit>(
        () => MyCoursesCubit(getIt<MyCoursesRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<TrainersRemoteDataSource>(
        () => TrainersRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<TrainersRepository>(
        () => TrainersRepositoryImpl(getIt<TrainersRemoteDataSource>()),
  );
  getIt.registerFactory<TrainersCubit>(
        () => TrainersCubit(getIt<TrainersRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<SectionFilesRemoteDataSource>(
        () => SectionFilesRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<SectionFilesRepository>(
        () => SectionFilesRepositoryImpl(getIt<SectionFilesRemoteDataSource>()),
  );
  getIt.registerFactory<SectionFilesCubit>(
        () => SectionFilesCubit(getIt<SectionFilesRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<ScheduleRemoteDataSource>(
        () => ScheduleRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ScheduleRepository>(
        () => ScheduleRepositoryImpl(getIt<ScheduleRemoteDataSource>()),
  );
  getIt.registerFactory<ScheduleCubit>(
        () => ScheduleCubit(getIt<ScheduleRepository>()),
  );
  //////////////////
  getIt.registerLazySingleton<ForumRemoteDataSource>(
          () => ForumRemoteDataSourceImpl(getIt<ApiService>()));
  getIt.registerLazySingleton<ForumRepository>(
          () => ForumRepositoryImpl(getIt<ForumRemoteDataSource>()));
  getIt.registerFactory<ForumCubit>(
          () => ForumCubit(getIt<ForumRepository>()));
  //////////////////
  getIt.registerLazySingleton<QuizRemoteDataSource>(
          () => QuizRemoteDataSourceImpl(getIt<ApiService>()));
  getIt.registerLazySingleton<QuizRepository>(
          () => QuizRepositoryImpl(getIt<QuizRemoteDataSource>()));
  getIt.registerFactory<QuizCubit>(() => QuizCubit(getIt<QuizRepository>()));
  //////////////////
  getIt.registerLazySingleton<SavedCoursesRemoteDataSource>(
        () => SavedCoursesRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<SavedCoursesRepository>(
        () => SavedCoursesRepositoryImpl(getIt<SavedCoursesRemoteDataSource>()),
  );
  getIt.registerFactory<SavedCoursesCubit>(
          () => SavedCoursesCubit(
        getIt<SavedCoursesRepository>(),
        getIt<MyCoursesRepository>(),
      ));

  //////////////////
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
          () => ProfileRemoteDataSourceImpl(getIt<ApiService>()));
  getIt.registerLazySingleton<ProfileRepository>(
          () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()));
  getIt.registerFactory<ProfileCubit>(
          () => ProfileCubit(getIt<ProfileRepository>()));
  //////////////////
  getIt.registerLazySingleton<AdsRemoteDataSource>(
        () => AdsRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AdsRepository>(
        () => AdsRepositoryImpl(getIt<AdsRemoteDataSource>()),
  );
  getIt.registerFactory<AdsCubit>(
        () => AdsCubit(getIt<AdsRepository>()),
  );

  //////////////////

  getIt.registerLazySingleton<RecommendationsRemoteDataSource>(
        () => RecommendationsRemoteDataSourceImpl(getIt<ApiService>()),
  );


  getIt.registerLazySingleton<RecommendationsRepository>(
        () => RecommendationsRepositoryImpl(getIt<RecommendationsRemoteDataSource>()),
  );


  getIt.registerLazySingleton<RecommendationsCubit>(
        () => RecommendationsCubit(getIt<RecommendationsRepository>()),
  );

  //////////////////
  getIt.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImpl(getIt<SearchRemoteDataSource>()),
  );
  getIt.registerFactory<SearchCubit>(
        () => SearchCubit(getIt<SearchRepository>()),
  );
  //////////////////

  getIt.registerLazySingleton<RatingsRemoteDataSource>(
        () => RatingsRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RatingsRepository>(
        () => RatingsRepositoryImpl(getIt<RatingsRemoteDataSource>()),
  );
  getIt.registerFactory<RatingsCubit>(
        () => RatingsCubit(getIt<RatingsRepository>()),
  );
  ///////////////////////
  getIt.registerSingleton<FirebaseService>(FirebaseService());
  getIt.registerSingleton<NotificationService>(NotificationService());

  await getIt<FirebaseService>().init();
  await getIt<NotificationService>().init();
  /////////////////////////////////
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
        () => NotificationsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
        () => NotificationsRepositoryImpl(getIt<NotificationsRemoteDataSource>()),
  );
  getIt.registerFactory<NotificationsCubit>(
        () => NotificationsCubit(getIt<NotificationsRepository>()),
  );
}


