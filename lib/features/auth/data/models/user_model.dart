class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final String birthday;
  final String gender;
  final int points;
  final int? referrerId;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.birthday,
    required this.gender,
    required this.points,
    this.referrerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String?,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      points: json['points'] as int,
      referrerId: json['referrer_id'] is int ? json['referrer_id'] as int : null,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
