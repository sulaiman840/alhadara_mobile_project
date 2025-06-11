import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../datasources/schedule_remote_data_source.dart';
import '../models/schedule_event_model.dart';

abstract class ScheduleRepository {
  Future<Either<StatusRequest, List<ScheduleEventModel>>> getScheduleByDay(String day);
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource _remote;
  ScheduleRepositoryImpl(this._remote);

  @override
  Future<Either<StatusRequest, List<ScheduleEventModel>>> getScheduleByDay(String day) =>
      _remote.getScheduleByDay(day);
}
