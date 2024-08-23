import '../entities/friend_entity.dart';

abstract class FriendRepository {
  Future<List<Friend>> searchPeople({required String query});
  Future<void> addFriends({required String uid, required Friend friend});
  Future<List<Friend>> getFriends({required String currentId});
  Future<List<Friend>> searchFriends(
      {required String currentId, required String query});
}
