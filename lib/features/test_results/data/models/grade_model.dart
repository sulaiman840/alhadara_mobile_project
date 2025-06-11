
/// Represents a “section” nested object inside a Grade.
class SectionModel {
  final int id;
  final String name;
  final int seatsOfNumber;
  final int reservedSeats;
  final String state;
  final String startDate;
  final String endDate;
  final int courseId;
  final String createdAt;
  final String updatedAt;

  SectionModel({
    required this.id,
    required this.name,
    required this.seatsOfNumber,
    required this.reservedSeats,
    required this.state,
    required this.startDate,
    required this.endDate,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      seatsOfNumber: json['seatsOfNumber'] as int,
      reservedSeats: json['reservedSeats'] as int,
      state: json['state'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      courseId: json['courseId'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

/// Represents a “trainer” nested object inside a Grade.
class TrainerModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final String birthday;
  final String gender;
  final String specialization;
  final String experience;
  final String createdAt;
  final String updatedAt;

  TrainerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.birthday,
    required this.gender,
    required this.specialization,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String?,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      specialization: json['specialization'] as String,
      experience: json['experience'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

/// Represents a single grade record, including nested `section` and `trainer`.
class GradeModel {
  final int id;
  final int studentId;
  final int sectionId;
  final int trainerId;
  final double grade;
  final String examDate;
  final String notes;
  final String createdAt;
  final String updatedAt;
  final SectionModel section;
  final TrainerModel trainer;

  GradeModel({
    required this.id,
    required this.studentId,
    required this.sectionId,
    required this.trainerId,
    required this.grade,
    required this.examDate,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.section,
    required this.trainer,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      sectionId: json['section_id'] as int,
      trainerId: json['trainer_id'] as int,
      grade: (json['grade'] as num).toDouble(),
      examDate: json['exam_date'] as String,
      notes: json['notes'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      section: SectionModel.fromJson(json['section'] as Map<String, dynamic>),
      trainer: TrainerModel.fromJson(json['trainer'] as Map<String, dynamic>),
    );
  }
}
