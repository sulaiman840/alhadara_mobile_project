import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart';
import 'features/menu_features/settings/cubit/locale_cubit.dart';
import 'features/menu_features/settings/cubit/theme_cubit.dart';
import 'core/localization/app_localizations_setup.dart';
import 'core/navigation/app_router.dart';
import 'core/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await FlutterDownloader.initialize(debug: true);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1)),
              child: ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (_, __) => MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: AppRouter.router,
                  locale: locale,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localizationsDelegates: AppLocalizationsSetup.delegates,
                  localeResolutionCallback:
                  AppLocalizationsSetup.localeResolutionCallback,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
