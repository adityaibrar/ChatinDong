import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessage {
  final ChatRepository chatRepository;

  const GetMessage(this.chatRepository);

  Stream<List<Chat>> execute({required String chatRoomId}) {
    return chatRepository.getMessage(chatRoomId);
  }
}
