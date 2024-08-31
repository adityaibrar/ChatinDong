import '../../domain/usecases/search_friends.dart';

import '../../../authentication/domain/usecases/auth_get_user.dart';
import '../../domain/usecases/get_friends.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/friend_entity.dart';
import '../../domain/usecases/add_friends.dart';
import '../../domain/usecases/search_people.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final AuthGetUser getUser;
  final AddFriends addFriends;
  final SearchPeople searchPeople;
  final GetFriends getFriends;
  final SearchFriends searchFriends;
  FriendsBloc({
    required this.getUser,
    required this.addFriends,
    required this.searchPeople,
    required this.getFriends,
    required this.searchFriends,
  }) : super(FriendsInitial()) {
    on<FriendsEvent>((event, emit) async {
      if (event is AddFriendsEvent) {
        emit(FriendLoading());
        try {
          final currentUser = await getUser.execute();
          await addFriends.execute(currentUser.uid, event.friend);
          emit(FriendAdded());
          add(GetFriendsEvent());
        } catch (e) {
          emit(FriendError(e.toString()));
        }
      }
      if (event is SearchPeopleEvent) {
        emit(FriendLoading());
        try {
          final friend = await searchPeople.execute(event.query);
          emit(FriendLoaded(friend));
        } catch (e) {
          emit(FriendError(e.toString()));
        }
      }
      if (event is GetFriendsEvent) {
        emit(FriendLoading());
        try {
          final currentUser = await getUser.execute();
          final result = await getFriends.execute(currentId: currentUser.uid);
          emit(FriendGet(result));
        } catch (e) {
          emit(FriendError(e.toString()));
        }
      }
      if (event is SearchMyFriends) {
        emit(FriendLoading());
        try {
          final currentUser = await getUser.execute();
          final result = await searchFriends.execute(
              currentId: currentUser.uid, query: event.query);
          emit(FriendLoaded(result));
        } catch (e) {
          emit(FriendError(e.toString()));
        }
      }
    });
  }
}
