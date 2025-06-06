import 'package:dio/dio.dart';
import '../models/trainer_with_course_model.dart';

abstract class TrainersRemoteDataSource {
  Future<List<TrainerWithCourse>> fetchAll();
}

class TrainersRemoteDataSourceImpl implements TrainersRemoteDataSource {
  final Dio _dio;
  TrainersRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TrainerWithCourse>> fetchAll() async {
    final resp = await _dio.get('api/trainer/indexTrainerWithCourse');
    if (resp.statusCode == 200) {
      final raw = (resp.data['Trainers']['data'] as List);
      return raw.map((j) => TrainerWithCourse.fromJson(j)).toList();
    }
    throw DioException(requestOptions: resp.requestOptions);
  }
}
