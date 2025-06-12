import 'package:equatable/equatable.dart';
import 'user_model_fourm.dart';

class AnswerModel extends Equatable {
  final int id;
  final int questionId;
  final int userId;
  final String userType;
  final String content;
  final bool isAccepted;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModelFourm user;

  const AnswerModel({
    required this.id,
    required this.questionId,
    required this.userId,
    required this.userType,
    required this.content,
    required this.isAccepted,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String raw) => DateTime.parse(raw);
    return AnswerModel(
      id: json['id'] as int,
      questionId: json['question_id'] as int,
      userId: json['user_id'] as int,
      userType: json['user_type'] as String,
      content: json['content'] as String,
      isAccepted: (json['is_accepted'] as bool?) ?? false,
      likesCount: (json['likes_count'] as int?) ?? 0,
      createdAt: parseDate(json['created_at'] as String),
      updatedAt: parseDate(json['updated_at'] as String),
      user: UserModelFourm.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [id, content, isAccepted, likesCount];
}
