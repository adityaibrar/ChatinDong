import 'package:chatin_dong/features/authentication/domain/entities/user_authentication.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        createdAt: map['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt,
    };
  }
}
