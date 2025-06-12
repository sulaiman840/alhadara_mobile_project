import 'package:equatable/equatable.dart';
import 'user_model_fourm.dart';
import 'answer_model.dart';
import 'like_model.dart';

class QuestionModel extends Equatable {
  final int id;
  final int courseSectionId;
  final int userId;
  final String userType;
  final String content;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModelFourm user;
  final List<AnswerModel> answers;
  final List<LikeModel> likes;

  const QuestionModel({
    required this.id,
    required this.courseSectionId,
    required this.userId,
    required this.userType,
    required this.content,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.answers,
    required this.likes,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String raw) => DateTime.parse(raw);
    return QuestionModel(
      id: json['id'] as int,
      courseSectionId: json['course_section_id'] as int,
      userId: json['user_id'] as int,
      userType: json['user_type'] as String,
      content: json['content'] as String,
      likesCount: json['likes_count'] as int? ?? 0,
      createdAt: parseDate(json['created_at'] as String),
      updatedAt: parseDate(json['updated_at'] as String),
      user: UserModelFourm.fromJson(json['user'] as Map<String, dynamic>),
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((a) => AnswerModel.fromJson(a as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as List<dynamic>? ?? [])
          .map((l) => LikeModel.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, courseSectionId, content, likesCount];
}
