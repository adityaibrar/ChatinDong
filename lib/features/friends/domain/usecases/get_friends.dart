import '../entities/friend_entity.dart';
import '../repositories/friend_repository.dart';

class GetFriends {
  final FriendRepository friendRepository;

  const GetFriends(this.friendRepository);

  Future<List<Friend>> execute({required String currentId}) async {
    return await friendRepository.getFriends(currentId: currentId);
  }
}
