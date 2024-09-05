import 'package:equatable/equatable.dart';

class Friend extends Equatable {
  final String uid;
  final String userName;
  final String email;
  final String imageUrl;

  const Friend({
    required this.uid,
    required this.userName,
    required this.email,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        uid,
        userName,
        email,
        imageUrl,
      ];
}
