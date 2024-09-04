import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? imageUrl;
  final DateTime createdAt;

  const User({
    required this.uid,
    required this.name,
    required this.email,
    this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        imageUrl,
        createdAt,
      ];
}
