import 'package:equatable/equatable.dart';
import '../../../home/data/models/course_model.dart';

class EnrolledCourseModel extends Equatable {
  /// From API: section_id
  final int id;

  /// From API: section_name
  final String name;

  /// From API: course { ... }
  final CourseModel course;

  /// From API: weekDays: [{ name, start_time, end_time }]
  /// Kept inline (no extra classes) as requested.
  final List<({String name, String startTime, String endTime})> weekDays;

  /// From API: exams -> exposed as `grades` to fit the UI you already use
  /// (List of inline records; no extra classes).
  final List<({int examId, String examName, double? grade})> grades;

  const EnrolledCourseModel({
    required this.id,
    required this.name,
    required this.course,
    required this.weekDays,
    required this.grades,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    // --- course ---
    final courseJson = (json['course'] as Map?)?.cast<String, dynamic>() ?? const {};

    // --- weekDays ---
    final weekDaysList = (json['weekDays'] as List?)
        ?.whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map<({String name, String startTime, String endTime})>((e) {
      return (
      name: (e['name'] as String?) ?? '',
      startTime: (e['start_time'] as String?) ?? '',
      endTime: (e['end_time'] as String?) ?? '',
      );
    }).toList() ??
        const <({String name, String startTime, String endTime})>[];

    // --- exams -> grades ---
    final examsList = (json['exams'] as List?)
        ?.whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map<({int examId, String examName, double? grade})>((e) {
      // grade can arrive as "85.50" (String) or number or null
      final rawGrade = e['grade'];
      double? parsedGrade;
      if (rawGrade is num) {
        parsedGrade = rawGrade.toDouble();
      } else if (rawGrade is String) {
        parsedGrade = rawGrade.trim().isEmpty ? null : double.tryParse(rawGrade);
      } else {
        parsedGrade = null;
      }

      return (
      examId: (e['exam_id'] as num?)?.toInt() ?? 0,
      examName: (e['exam_name'] as String?)?.trim() ?? '',
      grade: parsedGrade,
      );
    }).toList() ??
        const <({int examId, String examName, double? grade})>[];

    return EnrolledCourseModel(
      id: (json['section_id'] as num?)?.toInt() ?? 0,
      name: (json['section_name'] as String?) ?? '',
      course: CourseModel.fromJson(courseJson),
      weekDays: weekDaysList,
      grades: examsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'section_id': id,
    'section_name': name,
    'course': course.toJson(),
    'weekDays': weekDays
        .map((w) => {
      'name': w.name,
      'start_time': w.startTime,
      'end_time': w.endTime,
    })
        .toList(),
    'exams': grades
        .map((g) => {
      'exam_id': g.examId,
      'exam_name': g.examName,
      'grade': g.grade,
    })
        .toList(),
  };

  @override
  List<Object?> get props => [id, name, course, weekDays, grades];
}
