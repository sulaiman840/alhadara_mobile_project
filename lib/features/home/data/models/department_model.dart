import 'package:equatable/equatable.dart';

class DepartmentModel extends Equatable {
  final int id;
  final String name;
  final String photo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      photo: json['photo'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, photo, createdAt, updatedAt];
}
