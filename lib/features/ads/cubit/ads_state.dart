import 'package:equatable/equatable.dart';
import '../data/models/ads_page_model.dart';

abstract class AdsState extends Equatable {
  const AdsState();
  @override
  List<Object?> get props => [];
}

class AdsInitial extends AdsState {}
class AdsLoading extends AdsState {}
class AdsLoaded extends AdsState {
  final AdsPageModel page;
  const AdsLoaded(this.page);
  @override
  List<Object?> get props => [page];
}
class AdsFailure extends AdsState {
  final String message;
  const AdsFailure(this.message);
  @override
  List<Object?> get props => [message];
}
