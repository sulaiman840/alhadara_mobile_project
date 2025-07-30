
import 'package:equatable/equatable.dart';

class StudentModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final String birthday;
  final String gender;
  final String createdAt;
  final String updatedAt;
  final int points;
  final int? referrerId;

  const StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.birthday,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.points,
    this.referrerId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String?,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      points: json['points'] as int,
      referrerId:
      json['referrer_id'] is int ? json['referrer_id'] as int : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    photo,
    birthday,
    gender,
    createdAt,
    updatedAt,
    points,
    referrerId,
  ];
}

class GiftModel extends Equatable {
  final int id;
  final String description;
  final String date;
  final String? photo;
  final int studentId;
  final int? secretaryId;
  final String createdAt;
  final String updatedAt;
  final StudentModel student;

  const GiftModel({
    required this.id,
    required this.description,
    required this.date,
    this.photo,
    required this.studentId,
    this.secretaryId,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'] as int,
      description: json['description'] as String,
      date: json['date'] as String,
      photo: json['photo'] as String?,
      studentId: json['student_id'] as int,
      secretaryId:
      json['secretary_id'] is int ? json['secretary_id'] as int : null,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      student: StudentModel.fromJson(json['student'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
    id,
    description,
    date,
    photo,
    studentId,
    secretaryId,
    createdAt,
    updatedAt,
    student,
  ];
}
