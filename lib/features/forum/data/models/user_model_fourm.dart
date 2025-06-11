import 'package:equatable/equatable.dart';

class UserModelFourm extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? photo;
  final DateTime? birthday;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int points;
  final int? referrerId;

  const UserModelFourm({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photo,
    this.birthday,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.points,
    this.referrerId,
  });

  factory UserModelFourm.fromJson(Map<String, dynamic> json) {
    // parse dates safely
    DateTime parseDate(String? raw) {
      if (raw == null) return DateTime.now();
      try {
        return DateTime.parse(raw);
      } catch (_) {
        // try custom format e.g. yyyy/MM/dd
        final parts = raw.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
        return DateTime.now();
      }
    }

    return UserModelFourm(
      id: (json['id'] as int?) ?? 0,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
      birthday: parseDate(json['birthday'] as String?),
      gender: json['gender'] as String?,
      createdAt: parseDate(json['created_at'] as String?),
      updatedAt: parseDate(json['updated_at'] as String?),
      points: (json['points'] as int?) ?? 0,
      referrerId: json['referrer_id'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    photo,
    birthday,
    gender,
    createdAt,
    updatedAt,
    points,
    referrerId,
  ];
}
