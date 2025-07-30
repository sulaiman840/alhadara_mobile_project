import 'package:equatable/equatable.dart';
import '../data/models/gift_model.dart';

abstract class GiftsState extends Equatable {
  const GiftsState();

  @override
  List<Object?> get props => [];
}

class GiftsInitial extends GiftsState {}

class GiftsLoading extends GiftsState {}

class GiftsSuccess extends GiftsState {
  final List<GiftModel> gifts;
  const GiftsSuccess(this.gifts);

  @override
  List<Object?> get props => [gifts];
}

class GiftsFailure extends GiftsState {
  final String errorMessage;
  const GiftsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
