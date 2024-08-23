import 'package:equatable/equatable.dart';

class Friend extends Equatable {
  final String uid;
  final String userName;
  final String email;

  const Friend({
    required this.uid,
    required this.userName,
    required this.email,
  });

  @override
  List<Object?> get props => [uid, userName, email];
}
