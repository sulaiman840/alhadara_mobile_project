class FinishedCourseModel {
  final int id;
  final String sectionName;
  final int seatsOfNumber;
  final int reservedSeats;
  final String state;
  final String startDate;
  final String endDate;
  final int courseId;
  final int totalSessions;
  final CourseInfo course;
  final List<WeekDaySlot> weekDays;

  FinishedCourseModel({
    required this.id,
    required this.sectionName,
    required this.seatsOfNumber,
    required this.reservedSeats,
    required this.state,
    required this.startDate,
    required this.endDate,
    required this.courseId,
    required this.totalSessions,
    required this.course,
    required this.weekDays,
  });

  factory FinishedCourseModel.fromJson(Map<String, dynamic> json) {
    return FinishedCourseModel(
      id: json['id'] as int,
      sectionName: json['name'] as String,
      seatsOfNumber: (json['seatsOfNumber'] ?? 0) as int,
      reservedSeats: (json['reservedSeats'] ?? 0) as int,
      state: json['state'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      courseId: (json['courseId'] ?? 0) as int,
      totalSessions: (json['total_sessions'] ?? 0) as int,
      course: CourseInfo.fromJson(json['course'] as Map<String, dynamic>),
      weekDays: ((json['week_days'] ?? []) as List)
          .map((e) => WeekDaySlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CourseInfo {
  final int id;
  final String name;
  final String? description;
  final String? photo;

  CourseInfo({
    required this.id,
    required this.name,
    this.description,
    this.photo,
  });

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      photo: json['photo'] as String?,
    );
  }
}

class WeekDaySlot {
  final int id;
  final String name;
  final String startTime;
  final String endTime;

  WeekDaySlot({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory WeekDaySlot.fromJson(Map<String, dynamic> json) {
    final pivot = (json['pivot'] ?? {}) as Map<String, dynamic>;
    return WeekDaySlot(
      id: json['id'] as int,
      name: json['name'] as String,
      startTime: (pivot['start_time'] ?? '') as String,
      endTime: (pivot['end_time'] ?? '') as String,
    );
  }
}
