import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/localization/localization_service.dart';
import 'core/navigation/app_router.dart';

import 'core/injection.dart';
import 'core/utils/breakpoints.dart';
import 'core/utils/theme.dart';
import 'features/counter/state/counter_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(1)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScreenUtilInit(
            designSize: constraints.maxWidth < Breakpoints.medium
                ? const Size(375, 812)
                : const Size(1536, 792.8),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, __) => MultiBlocProvider(
              providers: [
                BlocProvider<CounterCubit>(
                  create: (_) => getIt<CounterCubit>()..loadCounter(),
                ),
                // add other BlocProviders here…
              ],
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                locale: LocalizationService.deviceLocale,
                localizationsDelegates: LocalizationService.delegates,
                supportedLocales: LocalizationService.supportedLocales,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
              ),
            ),
          );
        },
      ),
    );
  }
}