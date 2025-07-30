
import '../datasources/gifts_remote_data_source.dart';
import '../models/gift_model.dart';

abstract class GiftsRepository {
  Future<List<GiftModel>> fetchGifts();
}

class GiftsRepositoryImpl implements GiftsRepository {
  final GiftsRemoteDataSource _remoteDataSource;

  GiftsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<GiftModel>> fetchGifts() {
    return _remoteDataSource.getStudentGifts();
  }
}
