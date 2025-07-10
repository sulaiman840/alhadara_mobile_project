// lib/features/home/data/models/recommended_course_model.dart

class RecommendedCourse {
  final int id;
  final String name;
  final String description;
  final String photo;
  final int departmentId;
  final DateTime createdAt, updatedAt;

  RecommendedCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecommendedCourse.fromJson(Map<String, dynamic> json) {
    return RecommendedCourse(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      photo: json['photo'] as String,
      departmentId: json['department_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

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

/// A simple wrapper since the API returns { message, recommended_courses: [...] }
class RecommendedCoursesResponse {
  final List<RecommendedCourse> courses;

  RecommendedCoursesResponse({required this.courses});

  factory RecommendedCoursesResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['recommended_courses'] as List)
        .cast<Map<String, dynamic>>()
        .map((m) => RecommendedCourse.fromJson(m))
        .toList();
    return RecommendedCoursesResponse(courses: list);
  }
}
