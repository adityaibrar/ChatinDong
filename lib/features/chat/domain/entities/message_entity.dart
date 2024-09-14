import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? senderUid;
  final String? recipientUid;
  final String? senderName;
  final String? recipientName;
  final String? messageType;
  final String? message;
  final DateTime? createdAt;
  final bool? isSeen;
  final String? senderProfile;
  final String? recipientProfile;
  final String? messageId;
  final String? uid;

  const MessageEntity({
    this.senderUid,
    this.recipientUid,
    this.senderName,
    this.recipientName,
    this.messageType,
    this.message,
    this.createdAt,
    this.isSeen,
    this.senderProfile,
    this.recipientProfile,
    this.messageId,
    this.uid,
  });
  @override
  List<Object?> get props => [
        senderUid,
        recipientUid,
        senderName,
        recipientName,
        message,
        createdAt,
        isSeen,
        senderProfile,
        recipientProfile,
        messageId,
        uid,
      ];
}
