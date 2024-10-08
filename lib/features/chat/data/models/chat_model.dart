import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    super.senderUid,
    super.recipientUid,
    super.senderName,
    super.recipientName,
    super.recentTextMessage,
    super.createdAt,
    super.senderProfile,
    super.recipientProfile,
    super.totalUnreadMessages,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      senderUid: data['sender_uid'] as String?,
      recipientUid: data['recipient_uid'] as String?,
      senderName: data['sender_name'] as String?,
      recipientName: data['recipient_name'] as String?,
      recentTextMessage: data['recent_text_message'] as String?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      senderProfile: data['sender_profile'] as String?,
      recipientProfile: data['recipient_profile'] as String?,
      totalUnreadMessages: data['total_unread_messages'] as num?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender_uid': senderUid,
      'recipient_uid': recipientUid,
      'sender_name': senderName,
      'recipient_name': recipientName,
      'recent_text_message': recentTextMessage,
      'created_at': Timestamp.fromDate(DateTime.now()),
      'sender_profile': senderProfile,
      'recipient_profile': recipientProfile,
      'total_unread_messages': totalUnreadMessages,
    };
  }
}
