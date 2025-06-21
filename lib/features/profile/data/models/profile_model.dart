class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String birthday;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int points;
  final int? referrerId;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.birthday,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.points,
    this.referrerId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final p = json['profile'] as Map<String, dynamic>;
    return ProfileModel(
      id: p['id'] as int,
      name: p['name'] as String,
      email: p['email'] as String,
      phone: p['phone'] as String,
      photo: p['photo'] as String,
      birthday: p['birthday'] as String,
      gender: p['gender'] as String,
      createdAt: DateTime.parse(p['created_at'] as String),
      updatedAt: DateTime.parse(p['updated_at'] as String),
      points: p['points'] as int,
      referrerId: p['referrer_id'] as int?,
    );
  }
}