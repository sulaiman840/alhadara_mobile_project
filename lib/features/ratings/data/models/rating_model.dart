import 'student_model.dart';
class RatingModel {
  final int id;
  final int studentId;
  final int? courseSectionId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final StudentModel student;
  RatingModel({
    required this.id,
    required this.studentId,
    this.courseSectionId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.student,
  });
  factory RatingModel.fromJson(Map<String,dynamic> json) {
    // some APIs might omit the full "student" payload when you just create a rating
    final studentJson = json['student'];
    final student = (studentJson is Map<String, dynamic>)
        ? StudentModel.fromJson(studentJson)
    // fallback: we at least know the student_id, even if we don't have the name/photo
        : StudentModel(
      id: json['student_id'] as int,
      name: 'Unknown',
      photo: null,
    );

    return RatingModel(
      id:              json['id']               as int,
      studentId:       json['student_id']       as int,
      courseSectionId: json['course_section_id'] as int?,
      rating:          json['rating']           as int,
      comment:         json['comment']          as String?,
      createdAt:       DateTime.parse(json['created_at'] as String),
      student:         student,
    );
  }

}