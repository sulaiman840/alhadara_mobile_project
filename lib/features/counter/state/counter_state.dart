
import '../../../core/network/statusrequest.dart';
import '../data/models/counter_model.dart';

class CounterState {
  final Counter? counter;
  final StatusRequest status;

  CounterState({this.counter, this.status = StatusRequest.none});

  CounterState copyWith({Counter? counter, StatusRequest? status}) {
    return CounterState(
      counter: counter ?? this.counter,
      status: status ?? this.status,
    );
  }

  factory CounterState.initial() => CounterState(status: StatusRequest.none);
}