import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/localization/localization_service.dart';
import 'core/navigation/app_router.dart';
import 'core/injection.dart';
import 'core/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await FlutterDownloader.initialize(
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MaterialApp.router(
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
  }
}
