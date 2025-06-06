import '../datasources/trainers_remote_data_source.dart';
import '../models/trainer_with_course_model.dart';

abstract class TrainersRepository {
  Future<List<TrainerWithCourse>> getAll();
}

class TrainersRepositoryImpl implements TrainersRepository {
  final TrainersRemoteDataSource _remote;
  TrainersRepositoryImpl(this._remote);

  @override
  Future<List<TrainerWithCourse>> getAll() =>
      _remote.fetchAll();
}
