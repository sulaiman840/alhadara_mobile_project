import 'package:equatable/equatable.dart';

class ComplaintData extends Equatable {
  final int id;
  final String description;
  final String? filePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ComplaintData({
    required this.id,
    required this.description,
    this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintData.fromJson(Map<String, dynamic> json) {
    return ComplaintData(
      id: json['id'] as int,
      description: json['description'] as String,
      filePath: json['file_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, description, filePath, createdAt, updatedAt];
}

class ComplaintResponse extends Equatable {
  final String status;
  final String message;
  final ComplaintData data;

  const ComplaintResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: ComplaintData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [status, message, data];
}
