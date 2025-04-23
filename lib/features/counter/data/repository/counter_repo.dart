import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../datasources/counter_remote_ds.dart';
import '../models/counter_model.dart';

class CounterRepository {
  final CounterRemoteDataSource remoteDs;
  CounterRepository(this.remoteDs);

  Future<Either<StatusRequest, Counter>> getCounter() {
    return remoteDs.fetchCounter();
  }
}