import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../data/repositories/ads_repository.dart';
import '../data/models/ads_page_model.dart';
import '../../../../core/network/statusrequest.dart';
import 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final AdsRepository _repo;
  AdsCubit(this._repo) : super(AdsInitial());

  Future<void> fetchActiveAds() async {
    emit(AdsLoading());
    final Either<StatusRequest, AdsPageModel> result = await _repo.getActiveAds();
    result.fold(
          (fail) => emit(AdsFailure(fail.toString())),
          (page) => emit(AdsLoaded(page)),
    );
  }
}
