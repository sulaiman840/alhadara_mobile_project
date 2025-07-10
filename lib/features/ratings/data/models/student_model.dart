class StudentModel {
  final int id;
  final String name;
  final String? photo;
  StudentModel({ required this.id, required this.name, this.photo });
  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
    id: json['id'] as int,
    name: json['name'] as String,
    photo: json['photo'] as String?,
  );
}
