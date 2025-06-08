
class SectionFile {
  final int id;
  final String fileName;
  final String filePath;
  final DateTime createdAt;

  SectionFile({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
  });

  factory SectionFile.fromJson(Map<String, dynamic> json) {
    return SectionFile(
      id: json['id'] as int,
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
