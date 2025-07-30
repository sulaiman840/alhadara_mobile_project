
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/trainers_repository.dart';
import 'trainers_state.dart';

class TrainersCubit extends Cubit<TrainersState> {
  final TrainersRepository _repository;
  TrainersCubit(this._repository) : super(TrainersInitial());


  Future<void> fetchAll() async {
    emit(TrainersLoading());
    try {
      final list = await _repository.getAll();
      emit(TrainersLoaded(list));
    } catch (e, st) {
      debugPrint('TrainersCubit.fetchAll error: $e\n$st');
      emit(const TrainersError());
    }
  }
}
