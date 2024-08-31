String generateChatRoomId(String senderId, String receiverId) {
  return senderId.hashCode <= receiverId.hashCode
      ? '${senderId}_$receiverId'
      : '${receiverId}_$senderId';
}
