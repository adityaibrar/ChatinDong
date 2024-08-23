import 'package:chatin_dong/features/friends/domain/entities/friend_entity.dart';
import 'package:chatin_dong/features/friends/domain/repositories/friend_repository.dart';

class SearchFriends {
  final FriendRepository friendRepository;

  const SearchFriends(this.friendRepository);

  Future<List<Friend>> execute({required String currentId ,required String query}) async {
    return await friendRepository.searchFriends(currentId: currentId,query: query);
  }
}
