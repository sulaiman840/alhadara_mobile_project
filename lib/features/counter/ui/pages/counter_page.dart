import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/handling_data_view.dart';
import '../../state/counter_cubit.dart';
import '../../state/counter_state.dart';
import '../widgets/counter_button.dart';


class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocProvider(
        create: (_) => context.read<CounterCubit>()..loadCounter(),
        child: BlocBuilder<CounterCubit, CounterState>(
          builder: (context, state) {
            return HandlingDataView(
              statusRequest: state.status,
              child: Center(
                child: Text('Value: \${state.counter?.value ?? 0}'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: const CounterButton(),
    );
  }
}
