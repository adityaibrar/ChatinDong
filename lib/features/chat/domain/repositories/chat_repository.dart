import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<void> sendMessage(Chat chat);
  Stream<List<Chat>> getMessage(String chatRoomId);
}
