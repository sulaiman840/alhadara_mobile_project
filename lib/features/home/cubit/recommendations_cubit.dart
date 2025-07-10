// lib/features/home/cubit/recommendations_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../data/models/recommended_course_model.dart';
import '../data/repositories/recommendations_repository.dart';
import '../../../../core/network/statusrequest.dart';
import 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final RecommendationsRepository _repository;

  RecommendationsCubit(this._repository) : super(RecommendationsInitial());

  /// Fetch recommended courses and emit appropriate states.
  Future<void> fetchRecommendations() async {
    // prevent duplicate fetches
    if (state is RecommendationsLoading) return;

    emit(RecommendationsLoading());
    try {
      final result = await _repository.getRecommendations();

      result.fold(
        // If the API wrapper returns a StatusRequest failure, treat it as an exception
            (failure) => throw Exception(failure.toString()),
        // On success we expect the repository to return a model containing `courses`
            (response) {
          emit(RecommendationsSuccess(response.courses));
        },
      );
    } on DioException catch (e) {
      // Try to extract a server-provided message, otherwise fallback
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
