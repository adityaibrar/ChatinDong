import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String chatRoom;
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;

  const Chat({
    required this.chatRoom,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        chatRoom,
        content,
        senderId,
        receiverId,
        timestamp,
      ];
}
