import 'package:dartz/dartz.dart';
import '../../../../core/network/statusrequest.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<StatusRequest, ProfileModel>> getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;
  ProfileRepositoryImpl(this.remote);

  @override
  Future<Either<StatusRequest, ProfileModel>> getProfile() {
    return remote.fetchProfile();
  }
}