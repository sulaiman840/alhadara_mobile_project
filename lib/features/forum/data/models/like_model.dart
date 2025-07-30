import 'package:equatable/equatable.dart';
import 'user_model_fourm.dart';

class LikeModel extends Equatable {
  final int id;
  final UserModelFourm? user;

  const LikeModel({required this.id, this.user});

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    return LikeModel(
      id: json['id'] as int,
      user:
      userJson != null ? UserModelFourm.fromJson(userJson) : null,
    );
  }

  @override
  List<Object?> get props => [id, user];
}
