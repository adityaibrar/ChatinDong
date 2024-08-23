import '../entities/friend_entity.dart';
import '../repositories/friend_repository.dart';

class AddFriends {
  final FriendRepository friendRepository;

  const AddFriends(this.friendRepository);

  Future<void> execute(
    String uid,
    Friend friend,
  ) async {
    return await friendRepository.addFriends(
      uid: uid,
      friend: friend,
    );
  }
}
