import 'package:equatable/equatable.dart';
import '../../../home/data/models/course_model.dart';

/// A pared-down schedule event that only includes
/// the course and the *name* of the section.
class ScheduleEventModel extends Equatable {
  final CourseModel course;
  final String sectionName;
  final String startTime;
  final String endTime;

  const ScheduleEventModel({
    required this.course,
    required this.sectionName,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleEventModel.fromJson(Map<String, dynamic> json) {
    return ScheduleEventModel(
      course: CourseModel.fromJson(json['course'] as Map<String, dynamic>),
      sectionName: (json['section'] as Map<String, dynamic>)['name'] as String,
      startTime: json['start_time'] as String,
      endTime:   json['end_time']   as String,
    );
  }

  @override
  List<Object?> get props => [course, sectionName, startTime, endTime];
}
