
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../data/models/points_model.dart';
import '../data/repositories/points_repository.dart';
import 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  final PointsRepository _repository;

  PointsCubit(this._repository) : super(PointsInitial());

  Future<void> loadPoints() async {
    emit(PointsLoading());
    try {
      final PointsModel model = await _repository.fetchPoints();
      emit(PointsSuccess(model.points));
    } on DioException catch (e) {
      String message = 'تعذّر جلب النقاط';
      if (e.response?.data is Map<String, dynamic>) {
        final raw = e.response!.data as Map<String, dynamic>;
        if (raw.containsKey('message') && raw['message'] is String) {
          message = raw['message'] as String;
        }
      }
      emit(PointsFailure(message));
    } catch (_) {
      emit(const PointsFailure('خطأ غير متوقع'));
    }
  }
}
