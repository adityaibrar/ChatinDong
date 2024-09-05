import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_entity.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.chatRoom,
    required super.content,
    required super.senderId,
    required super.receiverId,
    required super.timestamp,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatRoom: map['chatRoom'] as String,
      content: map['content'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoom': chatRoom,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': Timestamp.fromDate(timestamp),
      'users': <String>[
        senderId,
        receiverId,
      ]
    };
  }
}
