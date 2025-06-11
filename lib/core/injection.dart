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
import '../features/complaints/cubit/complaints_cubit.dart';
import '../features/complaints/data/datasources/complaints_remote_data_source.dart';
import '../features/complaints/data/repositories/complaints_repository.dart';
import '../features/course_sections/cubit/sections_cubit.dart';
import '../features/course_sections/data/datasources/sections_remote_data_source.dart';
import '../features/course_sections/data/repositories/sections_repository.dart';
import '../features/forum/cubit/forum_cubit.dart';
import '../features/forum/data/datasources/forum_remote_data_source.dart';
import '../features/forum/data/repositories/forum_repository.dart';
import '../features/gifts/cubit/gifts_cubit.dart';
import '../features/gifts/data/datasources/gifts_remote_data_source.dart';
import '../features/gifts/data/repositories/gifts_repository.dart';
import '../features/home/cubit/courses_cubit.dart';
import '../features/home/cubit/departments_cubit.dart';
import '../features/home/cubit/points_cubit.dart';
import '../features/home/data/datasources/courses_remote_data_source.dart';
import '../features/home/data/datasources/departments_remote_data_source.dart';
import '../features/home/data/datasources/points_remote_data_source.dart';
import '../features/home/data/repositories/courses_repository.dart';
import '../features/home/data/repositories/departments_repository.dart';
import '../features/home/data/repositories/points_repository.dart';
import '../features/menu/cubit/logout_cubit/logout_cubit.dart';
import '../features/my_course_details/cubit/my_courses_cubit.dart';
import '../features/my_course_details/cubit/quiz_cubit.dart';
import '../features/my_course_details/cubit/section_files_cubit.dart';
import '../features/my_course_details/data/datasources/my_courses_remote_data_source.dart';
import '../features/my_course_details/data/datasources/quiz_remote_data_source.dart';
import '../features/my_course_details/data/datasources/section_files_remote_data_source.dart';
import '../features/my_course_details/data/repositories/my_courses_repository.dart';
import '../features/my_course_details/data/repositories/quiz_repository.dart';
import '../features/my_course_details/data/repositories/section_files_repository.dart';
import '../features/test_results/cubit/grades_cubit.dart';
import '../features/test_results/data/datasources/grades_remote_data_source.dart';
import '../features/test_results/data/repositories/grades_repository.dart';
import '../features/trainers/cubit/trainers_cubit.dart';
import '../features/trainers/data/datasources/trainers_remote_data_source.dart';
import '../features/trainers/data/repositories/trainers_repository.dart';
import 'network/api_service.dart';
import 'network/dio_client.dart';
import '../features/counter/data/datasources/counter_remote_ds.dart';
import '../features/counter/data/repository/counter_repo.dart';
import '../features/counter/cubit/counter_cubit.dart';

final GetIt getIt = GetIt.instance;


Future<void> initialServices() async {
  await configureDependencies();
}

Future<void> configureDependencies() async {
  getIt.registerLazySingleton(() => DioClient());
  getIt.registerLazySingleton(() => ApiService());
  // Counter feature
  getIt.registerLazySingleton(() => CounterRemoteDataSource(getIt<ApiService>()));
  getIt.registerLazySingleton(() => CounterRepository(getIt<CounterRemoteDataSource>()));
  getIt.registerFactory(() => CounterCubit(getIt<CounterRepository>()));

  // ─── AUTH FEATURE REGISTRATIONS ─────────────────────────────────────────────

  // 1. Provide Dio instance for AuthRemoteDataSource:
  getIt.registerLazySingleton<Dio>(
        () => getIt<DioClient>().dio,
  );

  // 2. AuthRemoteDataSource:
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // 3. AuthRepository:
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepository(getIt<AuthRemoteDataSource>()),
  );

  // 4. LoginCubit & VerifyCubit:
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
  getIt.registerFactory<PointsCubit>(
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

  getIt.registerFactory<DepartmentsCubit>(
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
  getIt.registerFactory<MyCoursesCubit>(
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
}


