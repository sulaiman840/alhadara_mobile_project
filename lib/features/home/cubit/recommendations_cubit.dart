
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/recommendations_repository.dart';
import 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final RecommendationsRepository _repository;

  RecommendationsCubit(this._repository) : super(RecommendationsInitial());

  Future<void> fetchRecommendations() async {
    if (state is RecommendationsLoading) return;

    emit(RecommendationsLoading());
    try {
      final result = await _repository.getRecommendations();

      result.fold(
            (failure) => throw Exception(failure.toString()),
            (response) {
          emit(RecommendationsSuccess(response.courses));
        },
      );
    } on DioException catch (e) {
      String msg = 'حدث خطأ أثناء جلب التوصيات';
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] is String) {
        msg = data['message'] as String;
      }
      emit(RecommendationsFailure(msg));
    } catch (_) {
      emit(const RecommendationsFailure('حدث خطأ غير متوقع'));
    }
  }
}
