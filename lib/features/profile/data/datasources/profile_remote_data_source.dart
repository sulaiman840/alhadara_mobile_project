import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/statusrequest.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<StatusRequest, ProfileModel>> fetchProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService api;
  ProfileRemoteDataSourceImpl(this.api);

  @override
  Future<Either<StatusRequest, ProfileModel>> fetchProfile() async {
    return api.get(
      'api/student/profile',
          (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }
}