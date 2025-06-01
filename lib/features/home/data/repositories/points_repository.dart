
import '../datasources/points_remote_data_source.dart';
import '../models/points_model.dart';

abstract class PointsRepository {
  Future<PointsModel> fetchPoints();
}

class PointsRepositoryImpl implements PointsRepository {
  final PointsRemoteDataSource _remoteDataSource;

  PointsRepositoryImpl(this._remoteDataSource);

  @override
  Future<PointsModel> fetchPoints() {
    return _remoteDataSource.getStudentPoints();
  }
}
