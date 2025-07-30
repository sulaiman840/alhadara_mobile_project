import 'package:dartz/dartz.dart';
import '../../../../../core/network/statusrequest.dart';
import '../datasources/ads_remote_data_source.dart';
import '../models/ads_page_model.dart';

abstract class AdsRepository {
  Future<Either<StatusRequest, AdsPageModel>> getActiveAds();
}

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource _ds;
  AdsRepositoryImpl(this._ds);

  @override
  Future<Either<StatusRequest, AdsPageModel>> getActiveAds() =>
      _ds.fetchActiveAds();
}
