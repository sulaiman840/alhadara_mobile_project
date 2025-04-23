
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/counter/state/counter_cubit.dart';
import '../../features/counter/ui/pages/counter_page.dart';
import '../injection.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider<CounterCubit>(
            create: (_) => getIt<CounterCubit>()..loadCounter(),
            child: const CounterPage(),
          );
        },
      ),

      // additional routes here
    ],
  );
}
