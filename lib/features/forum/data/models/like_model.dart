// lib/features/forum/data/models/like_model.dart
import 'package:alhadara_mobile_project/features/forum/data/models/user_model_fourm.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';

class LikeModel extends Equatable {
  final int id;
  final UserModelFourm? user;    // ← nullable now

  const LikeModel({ required this.id, this.user });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    return LikeModel(
      id: json['id'] as int,
      user: userJson != null
          ? UserModelFourm.fromJson(userJson)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, user];
}
