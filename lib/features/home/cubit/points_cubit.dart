
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../data/models/points_model.dart';
import '../data/repositories/points_repository.dart';
import 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  final PointsRepository _repository;

  PointsCubit(this._repository) : super(PointsInitial());

  Future<void> loadPoints() async {
    if (state is PointsLoading) return;
    emit(PointsLoading());
    try {
      final model = await _repository.fetchPoints();
      emit(PointsSuccess(model.points));
    } on DioException catch (e) {
      final msg = (e.response?.data is Map &&
          (e.response!.data as Map).containsKey('message'))
          ? (e.response!.data['message'] as String)
          : 'تعذّر جلب النقاط';
      emit(PointsFailure(msg));
    } catch (_) {
      emit(const PointsFailure('خطأ غير متوقع'));
    }
  }
}
