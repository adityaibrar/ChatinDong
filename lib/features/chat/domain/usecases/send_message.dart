import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository chatRepository;

  const SendMessage(this.chatRepository);

  Future<void> execute({required Chat chat}) async {
    return chatRepository.sendMessage(chat);
  }
}
