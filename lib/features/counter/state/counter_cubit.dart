import 'package:bloc/bloc.dart';
import '../../../core/network/statusrequest.dart';
import 'counter_state.dart';
import '../data/repository/counter_repo.dart';



class CounterCubit extends Cubit<CounterState> {
  final CounterRepository repository;
  CounterCubit(this.repository) : super(CounterState.initial());

  Future<void> loadCounter() async {
    emit(state.copyWith(status: StatusRequest.loading));
    final result = await repository.getCounter();
    result.fold(
          (fail) => emit(state.copyWith(status: fail)),
          (counter) => emit(state.copyWith(status: StatusRequest.success, counter: counter)),
    );
  }
}