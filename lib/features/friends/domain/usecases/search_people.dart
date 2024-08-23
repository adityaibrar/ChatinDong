import '../entities/friend_entity.dart';
import '../repositories/friend_repository.dart';

class SearchPeople {
  final FriendRepository friendRepository;

  const SearchPeople(this.friendRepository);

  Future<List<Friend>> execute(String query) async {
    return await friendRepository.searchPeople(query: query);
  }
}
