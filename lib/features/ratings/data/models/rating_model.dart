import 'student_model.dart';

class RatingModel {
  final int id;
  final int studentId;
  final int? trainerId;
  final int? courseSectionId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final StudentModel student;

  RatingModel({
    required this.id,
    required this.studentId,
    this.trainerId,
    this.courseSectionId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.student,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    id: json['id'],
    studentId: json['student_id'],
    trainerId: json['trainer_id'] as int?,
    courseSectionId: json['course_section_id'] as int?,
    rating: json['rating'],
    comment: json['comment'],
    createdAt: DateTime.parse(json['created_at']),
    student: StudentModel.fromJson(json['student']),
  );
}
