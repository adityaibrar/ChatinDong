import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    super.senderUid,
    super.recipientUid,
    super.senderName,
    super.recipientName,
    super.messageType,
    super.message,
    super.createdAt,
    super.isSeen,
    super.senderProfile,
    super.recipientProfile,
    super.messageId,
    super.uid,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MessageModel(
      senderUid: data['sender_uid'] as String?,
      recipientUid: data['recipient_uid'] as String?,
      senderName: data['sender_name'] as String?,
      recipientName: data['recipient_name'] as String?,
      messageType: data['message_type'] as String?,
      message: data['message'] as String?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      isSeen: data['is_seen'] as bool?,
      senderProfile: data['sender_profile'] as String?,
      recipientProfile: data['recipient_profile'] as String?,
      messageId: data['message_id'] as String?,
      uid: data['uid'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender_uid': senderUid,
      'recipient_uid': recipientUid,
      'sender_name': senderName,
      'recipient_name': recipientName,
      'message_type': messageType,
      'message': message,
      'created_at': Timestamp.fromDate(DateTime.now()),
      'is_seen': isSeen,
      'sender_profile': senderProfile,
      'recipient_profile': recipientProfile,
      'message_id': messageId,
      'uid': uid,
    };
  }
}
