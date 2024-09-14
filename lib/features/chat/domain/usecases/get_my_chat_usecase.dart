import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetMyChatUsecase {
  final ChatRepository _chatRepository;

  const GetMyChatUsecase(this._chatRepository);

  Stream<List<ChatEntity>> execute(ChatEntity chat) {
    return _chatRepository.getMyChat(chat);
  }
}
