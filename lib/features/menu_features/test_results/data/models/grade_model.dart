class GradeModel {
  final int id;
  final double grade;
  final String examDate;
  final String examName;
  final String trainerName;

  GradeModel({
    required this.id,
    required this.grade,
    required this.examDate,
    required this.examName,
    required this.trainerName,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    final exam = json['exam'] as Map<String, dynamic>;
    final trainer = json['trainer'] as Map<String, dynamic>;

    return GradeModel(
      id: json['id'] as int,
      grade: double.parse(json['grade'] as String),
      examDate: exam['exam_date'] as String,
      examName: exam['name'] as String,
      trainerName: trainer['name'] as String,
    );
  }
}
