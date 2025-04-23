import 'package:get_it/get_it.dart';
import 'network/api_service.dart';
import 'network/dio_client.dart';
import '../features/counter/data/datasources/counter_remote_ds.dart';
import '../features/counter/data/repository/counter_repo.dart';
import '../features/counter/state/counter_cubit.dart';

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
}
