// lib/features/ads/cubit/ads_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../data/models/ads_page_model.dart';
import '../data/repositories/ads_repository.dart';
import 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final AdsRepository _repo;

  AdsCubit(this._repo) : super(const AdsInitial());

  Future<void> fetchActiveAds() async {
    emit(const AdsLoading());
    final result = await _repo.getActiveAds();
    result.fold(
          (failure) => emit(AdsFailure(failure.toString())),
          (page)    => emit(AdsLoaded(page)),
    );
  }
}
