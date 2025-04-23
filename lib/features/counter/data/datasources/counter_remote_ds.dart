
import 'package:dartz/dartz.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/counter_model.dart';

typedef CounterParser = Counter Function(dynamic json);

class CounterRemoteDataSource {
  final ApiService apiService;
  CounterRemoteDataSource(this.apiService);

  Future<Either<StatusRequest, Counter>> fetchCounter() {
    return apiService.get<Counter>('/counter', (json) => Counter.fromJson(json));
  }
}
