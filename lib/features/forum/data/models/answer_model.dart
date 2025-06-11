import 'package:alhadara_mobile_project/features/forum/data/models/user_model_fourm.dart';
import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_model.dart';

class AnswerModel extends Equatable {
  final int id;
  final int questionId;
  final int userId;
  final String userType;
  final String content;
  final bool isAccepted;
  final UserModelFourm user;

  const AnswerModel({
    required this.id,
    required this.questionId,
    required this.userId,
    required this.userType,
    required this.content,
    required this.isAccepted,
    required this.user,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] as int,
      questionId: json['question_id'] as int,
      userId: json['user_id'] as int,
      userType: json['user_type'] as String,
      content: json['content'] as String,
      // ← safe‐cast to bool? and default
      isAccepted: (json['is_accepted'] as bool?) ?? false,
      user: UserModelFourm.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [id, content];
}
