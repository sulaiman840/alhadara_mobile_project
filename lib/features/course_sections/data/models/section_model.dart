

class SectionModel {
  final int id;
  final String name;
  final int seatsOfNumber;
  final int reservedSeats;
  final String state;
  final DateTime startDate;
  final DateTime endDate;
  final int courseId;
  final List<WeekDayModel> weekDays;
  final List<TrainerModel> trainers;

  SectionModel({
    required this.id,
    required this.name,
    required this.seatsOfNumber,
    required this.reservedSeats,
    required this.state,
    required this.startDate,
    required this.endDate,
    required this.courseId,
    required this.weekDays,
    required this.trainers,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      seatsOfNumber: json['seatsOfNumber'] as int,
      reservedSeats: json['reservedSeats'] as int,
      state: json['state'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      courseId: json['courseId'] as int,
      weekDays: (json['week_days'] as List<dynamic>)
          .map((e) => WeekDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      trainers: (json['trainers'] as List<dynamic>)
          .map((e) => TrainerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WeekDayModel {
  final int id;
  final String name;
  final String startTime;
  final String endTime;

  WeekDayModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory WeekDayModel.fromJson(Map<String, dynamic> json) {
    final pivot = json['pivot'] as Map<String, dynamic>;
    return WeekDayModel(
      id: json['id'] as int,
      name: json['name'] as String,
      startTime: pivot['start_time'] as String,
      endTime: pivot['end_time'] as String,
    );
  }
}
class TrainerModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final DateTime birthday;
  final String gender;
  final String specialization;
  final String experience;

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
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    // Manually parse "yyyy/MM/dd" into a DateTime:
    final rawBirthday = json['birthday'] as String;
    final parts = rawBirthday.split('/');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    return TrainerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String?,
      birthday: DateTime(year, month, day),
      gender: json['gender'] as String,
      specialization: json['specialization'] as String,
      experience: json['experience'] as String,
    );
  }
}
