class SectionProgress {
  final String message;
  final int progressPercentage;

  SectionProgress({
    required this.message,
    required this.progressPercentage,
  });

  factory SectionProgress.fromJson(Map<String, dynamic> json) {
    return SectionProgress(
      message: (json['message'] ?? '').toString(),
      progressPercentage: int.tryParse('${json['progress_percentage'] ?? 0}') ?? 0,
    );
  }
}
