import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../data/models/schedule_event_model.dart';
import '../data/repositories/schedule_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository _repo;
  ScheduleCubit(this._repo) : super(ScheduleInitial());

  Future<void> fetchByDay(String dayName) async {
    emit(ScheduleLoading());
    final Either<StatusRequest, List<ScheduleEventModel>> result =
    await _repo.getScheduleByDay(dayName);
    result.fold(
          (failure) => emit(ScheduleError(failure.toString())),
          (events)  => emit(ScheduleLoaded(events)),
    );
  }
}
