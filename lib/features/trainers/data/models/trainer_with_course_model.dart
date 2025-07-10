// lib/features/trainers/data/models/trainer_with_course_model.dart

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

  Map<String, dynamic> toJson() => {
    'trainer_id': trainerId,
    'trainer': trainer.toJson(),
    'course': course.toJson(),
  };
}

class Trainer {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final String birthday;
  final String gender;
  final String specialization;
  final String experience;

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

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    photo: json['photo'] as String?,
    birthday: json['birthday'] as String,
    gender: json['gender'] as String,
    specialization: json['specialization'] as String,
    experience: json['experience'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    if (photo != null) 'photo': photo,
    'birthday': birthday,
    'gender': gender,
    'specialization': specialization,
    'experience': experience,
  };
}

class Course {
  final int id;
  final String name;
  final String description;
  final String photo;
  final int departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'photo': photo,
    'department_id': departmentId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

/*class TrainerWithCourse {
  final int trainerId;
  final Trainer trainer;
  final Course course;
  final int pivotCourseSectionId;

  TrainerWithCourse({
    required this.trainerId,
    required this.trainer,
    required this.course,
    required this.pivotCourseSectionId,
  });

  factory TrainerWithCourse.fromJson(Map<String, dynamic> json) {
    final pivot = (json['trainer'] as Map<String, dynamic>)['pivot'] as Map<String, dynamic>;
    return TrainerWithCourse(
      trainerId: json['trainer_id'] as int,
      trainer: Trainer.fromJson(json['trainer'] as Map<String, dynamic>),
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
      pivotCourseSectionId: pivot['course_section_id'] as int,
    );
  }
}

class Trainer {
  final int id;
  final String name, email, phone;
  final String? photo;
  final String birthday;
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

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    photo: json['photo'] as String?,
    birthday: json['birthday'] as String,
    gender: json['gender'] as String,
    specialization: json['specialization'] as String,
    experience: json['experience'] as String,
  );
}
class Course {
  final int id;
  final String name, description, photo;
  final int departmentId;
  final DateTime createdAt, updatedAt;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
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
}*/