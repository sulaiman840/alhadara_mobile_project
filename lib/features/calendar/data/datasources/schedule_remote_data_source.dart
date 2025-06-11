import 'package:dartz/dartz.dart';
import 'package:alhadara_mobile_project/core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/schedule_event_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<Either<StatusRequest, List<ScheduleEventModel>>> getScheduleByDay(String day);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ApiService _api;
  ScheduleRemoteDataSourceImpl(this._api);

  @override
  Future<Either<StatusRequest, List<ScheduleEventModel>>> getScheduleByDay(String day) =>
      _api.get<List<ScheduleEventModel>>(
        'api/student/events/getMyScheduleByDay/$day',
            (json) {
              final list = (json['Events'] as List)
                  .map((e) => ScheduleEventModel.fromJson(e as Map<String, dynamic>))
                  .toList();
          return list;
        },
      );
}
