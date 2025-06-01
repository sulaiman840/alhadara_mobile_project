// lib/features/gifts/cubit/gifts_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/models/gift_model.dart';
import '../data/repositories/gifts_repository.dart';
import 'gifts_state.dart';

class GiftsCubit extends Cubit<GiftsState> {
  final GiftsRepository _repository;

  GiftsCubit(this._repository) : super(GiftsInitial());

  Future<void> loadGifts() async {
    emit(GiftsLoading());

    try {
      final giftsList = await _repository.fetchGifts();
      emit(GiftsSuccess(giftsList));
    } on DioException catch (e) {
      // Try to extract a message from the server response if available:
      String message = 'حدث خطأ أثناء جلب الهدايا';
      if (e.response?.data is Map<String, dynamic>) {
        final raw = e.response!.data as Map<String, dynamic>;
        if (raw.containsKey('message') && raw['message'] is String) {
          message = raw['message'] as String;
        }
      }
      emit(GiftsFailure(message));
    } catch (_) {
      emit(const GiftsFailure('حدث خطأ غير متوقع'));
    }
  }
}
