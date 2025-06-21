// lib/features/home/data/models/course_model.dart

import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String photo;
  final int departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converts this CourseModel into a JSON‐serializable map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'photo': photo,
    'department_id': departmentId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Reconstructs a CourseModel from a map (e.g. from JSON or GoRouter extra).
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      photo: json['photo'] as String,
      departmentId: json['department_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    photo,
    departmentId,
    createdAt,
    updatedAt,
  ];
}
