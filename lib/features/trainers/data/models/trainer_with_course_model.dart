class TrainerWithCourse {
  final int trainerId;
  final Trainer trainer;
  final Course course;

  TrainerWithCourse({
    required this.trainerId,
    required this.trainer,
    required this.course,
  });

  factory TrainerWithCourse.fromJson(Map<String, dynamic> json) {
    return TrainerWithCourse(
      trainerId: json['trainer_id'] as int,
      trainer: Trainer.fromJson(json['trainer'] as Map<String, dynamic>),
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
    );
  }
}


class Trainer {
  final int id;
  final String name, email, phone;
  final String? photo;
  final String birthday;       // ← change to String
  final String gender, specialization, experience;

  Trainer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.birthday,
    required this.gender,
    required this.specialization,
    required this.experience,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String?,
      birthday: json['birthday'] as String,         // ← no parse
      gender: json['gender'] as String,
      specialization: json['specialization'] as String,
      experience: json['experience'] as String,
    );
  }
}

class Course {
  final int id;
  final String name, description, photo;
  final int departmentId;
  final DateTime createdAt, updatedAt;

  Course({
    required this.id, required this.name,
    required this.description, required this.photo,
    required this.departmentId,
    required this.createdAt, required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    photo: json['photo'] as String,
    departmentId: json['department_id'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
