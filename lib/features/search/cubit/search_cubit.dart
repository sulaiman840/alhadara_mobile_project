import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../data/models/search_course_model.dart';
import '../data/repositories/search_repository.dart';
import '../../../../core/network/statusrequest.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repo;
  SearchCubit(this._repo) : super(SearchInitial());

  Future<void> search(String query) async {
    if (state is SearchLoading) return;
    emit(SearchLoading());
    final Either<StatusRequest, SearchCourseModel> res = await _repo.searchCourses(query);
    res.fold(
          (fail) => emit(SearchFailure(_mapError(fail))),
          (data) => emit(SearchSuccess(data)),
    );
  }

  String _mapError(StatusRequest e) {
    switch (e) {
      case StatusRequest.offlinefailure:
        return 'لا يوجد اتصال بالإنترنت';
      case StatusRequest.serverfailure:
        return 'خطأ في الخادم';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
