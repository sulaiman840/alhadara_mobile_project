class AdModel {
  final int id;
  final String title;
  final String description;
  final String? photo;
  final DateTime startDate;
  final DateTime endDate;

  AdModel({
    required this.id,
    required this.title,
    required this.description,
    this.photo,
    required this.startDate,
    required this.endDate,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    photo: json['photo'] as String?,
    startDate: DateTime.parse(json['start_date'] as String),
    endDate: DateTime.parse(json['end_date'] as String),
  );
}
