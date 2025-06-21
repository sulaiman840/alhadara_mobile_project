import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/statusrequest.dart';
import '../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await repository.getProfile();
    result.fold(
          (failure) => emit(ProfileError(_mapFailure(failure))),
          (profile) => emit(ProfileLoaded(profile)),
    );
  }

  String _mapFailure(StatusRequest r) {
    switch (r) {
      case StatusRequest.offlinefailure:
        return 'تحقق من الاتصال بالإنترنت';
      default:
        return 'حدث خطأ، حاول لاحقاً';
    }
  }
}