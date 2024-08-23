import '../datasources/friend_remote.dart';
import '../models/friend_model.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/repositories/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendRemoteDataSources friendRemoteDataSources;

  FriendRepositoryImpl(this.friendRemoteDataSources);

  @override
  Future<void> addFriends({
    required String uid,
    required Friend friend,
  }) async {
    try {
      final friendModel = FriendModel.fromEntity(friend);
      await friendRemoteDataSources.addFriends(
        uid: uid,
        friendModel: friendModel,
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan menambahkan teman: $e');
    }
  }

  @override
  Future<List<Friend>> searchPeople({required String query}) async {
    try {
      final friends = await friendRemoteDataSources.searchPeople(query: query);
      return friends.map((doc) => doc.toEntity()).toList();
    } catch (e) {
      throw Exception('Terjadi Kesalahan mencari orang: $e');
    }
  }

  @override
  Future<List<Friend>> getFriends({required String currentId}) async {
    try {
      final friends =
          await friendRemoteDataSources.getFriends(userId: currentId);
      return friends.map((doc) => doc.toEntity()).toList();
    } catch (e) {
      throw Exception('Terjadi kesalahan menampilkan teman:$e');
    }
  }

  @override
  Future<List<Friend>> searchFriends({
    required String currentId,
    required String query,
  }) async {
    try {
      final resultFriends = await friendRemoteDataSources.searchFriends(
        userId: currentId,
        query: query,
      );

      return resultFriends.map((doc) => doc.toEntity()).toList();
    } catch (e) {
      throw Exception('Terjadi Kesalah Mencari Teman $e');
    }
  }
}
