import 'package:equatable/equatable.dart';
import '../../../home/data/models/course_model.dart';

class EnrolledCourseModel extends Equatable {
  final int id;
  final String name;
  final int seatsOfNumber;
  final int reservedSeats;
  final String state;
  final DateTime startDate;
  final DateTime endDate;
  final int courseId;
  final CourseModel course;

  const EnrolledCourseModel({
    required this.id,
    required this.name,
    required this.seatsOfNumber,
    required this.reservedSeats,
    required this.state,
    required this.startDate,
    required this.endDate,
    required this.courseId,
    required this.course,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    return EnrolledCourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      seatsOfNumber: json['seatsOfNumber'] as int,
      reservedSeats: json['reservedSeats'] as int,
      state: json['state'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      courseId: json['courseId'] as int,
      course: CourseModel.fromJson(json['course'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
    id, name, seatsOfNumber, reservedSeats,
    state, startDate, endDate, courseId, course
  ];
}