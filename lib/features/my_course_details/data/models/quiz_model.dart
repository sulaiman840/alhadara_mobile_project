import 'package:equatable/equatable.dart';


class QuizModel extends Equatable {
  final int id;
  final String title;
  final int courseSectionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionModel> questions;

  const QuizModel({
    required this.id,
    required this.title,
    required this.courseSectionId,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as int,
      title: json['title'] as String,
      courseSectionId: json['course_section_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      questions: (json['quiz_question'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, title, questions];
}


class QuestionModel extends Equatable {
  final int id;
  final String question;
  final int quizId;
  final List<OptionModel> options;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.quizId,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int,
      question: json['question'] as String,
      quizId: json['quiz_id'] as int,
      options: (json['quiz_question_option'] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, question, options];
}

class OptionModel extends Equatable {
  final int id;
  final String optionText;
  final bool isCorrect;
  final int selectedCount;

  const OptionModel({
    required this.id,
    required this.optionText,
    required this.isCorrect,
    required this.selectedCount,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'] as int,
      optionText: json['option'] as String,
      isCorrect: (json['is_correct'] as int) == 1,
      selectedCount: json['selected_count'] as int,
    );
  }

  @override
  List<Object?> get props => [id, optionText, isCorrect, selectedCount];
}

class AnswerResponseModel extends Equatable {
  final bool isCorrect;
  final List<ResultOption> options;

  const AnswerResponseModel({
    required this.isCorrect,
    required this.options,
  });

  factory AnswerResponseModel.fromJson(Map<String, dynamic> json) {
    return AnswerResponseModel(
      isCorrect: (json['is_correct'] as int) == 1,
      options: (json['options'] as List<dynamic>)
          .map((e) => ResultOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [isCorrect, options];
}

class ResultOption extends Equatable {
  final int optionId;
  final String optionText;
  final bool isCorrect;
  final int selectedCount;
  final int percentage;

  const ResultOption({
    required this.optionId,
    required this.optionText,
    required this.isCorrect,
    required this.selectedCount,
    required this.percentage,
  });

  factory ResultOption.fromJson(Map<String, dynamic> json) {
    return ResultOption(
      optionId: json['option_id'] as int,
      optionText: json['option_text'] as String,
      isCorrect: (json['is_correct'] as int) == 1,
      selectedCount: json['selected_count'] as int,
      percentage: json['percentage'] as int,
    );
  }

  @override
  List<Object?> get props => [optionId, isCorrect, percentage];
}
