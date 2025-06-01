
class VerificationResponseModel {
  final String message;

  VerificationResponseModel({ required this.message });

  factory VerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return VerificationResponseModel(
      message: json['Message'] as String,
    );
  }
}
