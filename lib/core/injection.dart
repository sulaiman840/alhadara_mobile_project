import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/cubit/forgot_password_cubit.dart';
import '../features/auth/cubit/login_cubit.dart';
import '../features/auth/cubit/reset_password_cubit.dart';
import '../features/auth/cubit/verify_cubit.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/complaints/cubit/complaints_cubit.dart';
import '../features/complaints/data/datasources/complaints_remote_data_source.dart';
import '../features/complaints/data/repositories/complaints_repository.dart';
import '../features/gifts/cubit/gifts_cubit.dart';
import '../features/gifts/data/datasources/gifts_remote_data_source.dart';
import '../features/gifts/data/repositories/gifts_repository.dart';
import '../features/home/cubit/points_cubit.dart';
import '../features/home/data/datasources/points_remote_data_source.dart';
import '../features/home/data/repositories/points_repository.dart';
import '../features/menu/cubit/logout_cubit/logout_cubit.dart';
import '../features/test_results/cubit/grades_cubit.dart';
import '../features/test_results/data/datasources/grades_remote_data_source.dart';
import '../features/test_results/data/repositories/grades_repository.dart';
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

}


