import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'trainers_state.dart';
import '../data/repositories/trainers_repository.dart';

class TrainersCubit extends Cubit<TrainersState> {
  final TrainersRepository _repo;
  TrainersCubit(this._repo) : super(TrainersLoading());

  Future<void> fetchAll() async {
    try {
      final list = await _repo.getAll();
      emit(TrainersLoaded(list));
    } catch (e) {
      debugPrint('⚠️ TrainersCubit.fetchAll error: $e\n');

      emit(TrainersError('فشل في جلب البيانات'));
    }
  }
}
