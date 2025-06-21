import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/ads_page_model.dart';

abstract class AdsRemoteDataSource {
  Future<Either<StatusRequest, AdsPageModel>> fetchActiveAds();
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiService _api;

  AdsRemoteDataSourceImpl(this._api);

  @override
  Future<Either<StatusRequest, AdsPageModel>> fetchActiveAds() {
    return _api.get(
      'api/student/ads/active',
          (json) => AdsPageModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
