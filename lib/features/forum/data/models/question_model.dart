import 'package:alhadara_mobile_project/features/forum/data/models/user_model_fourm.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../course_sections/data/models/section_model.dart';
import 'answer_model.dart';
import 'like_model.dart';



class QuestionModel extends Equatable {
  final int id;
  final int sectionId;
  final int userId;
  final String userType;
  final String title;
  final String content;
  final bool isResolved;
  final List<AnswerModel> answers;
  final List<LikeModel> likes;
  final SectionModel? section;    // ← now optional
  final UserModelFourm user;

  const QuestionModel({
    required this.id,
    required this.sectionId,
    required this.userId,
    required this.userType,
    required this.title,
    required this.content,
    required this.isResolved,
    required this.answers,
    required this.likes,
    this.section,
    required this.user,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int,
      sectionId: json['section_id'] as int,
      userId: json['user_id'] as int,
      userType: json['user_type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      // ← safe‐cast and default:
      isResolved: (json['is_resolved'] as bool?) ?? false,
      answers: (json['answers'] as List<dynamic>?)
          ?.map((a) => AnswerModel.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
      likes: (json['likes'] as List<dynamic>?)
          ?.map((l) => LikeModel.fromJson(l as Map<String, dynamic>))
          .toList() ?? [],
      section: json['section'] != null
          ? SectionModel.fromJson(json['section'] as Map<String, dynamic>)
          : null,
      user: UserModelFourm.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [id, title, answers, likes, section, user];
}

