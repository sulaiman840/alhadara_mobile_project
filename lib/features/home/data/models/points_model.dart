
import 'package:equatable/equatable.dart';


class PointsModel extends Equatable {
  final int points;

  const PointsModel({required this.points});

  factory PointsModel.fromJson(Map<String, dynamic> json) {
    return PointsModel(
      points: json['points'] as int,
    );
  }

  @override
  List<Object?> get props => [points];
}
