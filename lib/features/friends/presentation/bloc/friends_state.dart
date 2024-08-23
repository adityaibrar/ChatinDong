part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendLoading extends FriendsState {}

class FriendLoaded extends FriendsState {
  final List<Friend> friends;

  const FriendLoaded(this.friends);

  @override
  List<Object> get props => [friends];
}

class FriendGet extends FriendsState {
  final List<Friend> myFriends;

  const FriendGet(this.myFriends);

  @override
  List<Object> get props => [myFriends];
}

class FriendAdded extends FriendsState {}

class FriendError extends FriendsState {
  final String message;

  const FriendError(this.message);

  @override
  List<Object> get props => [message];
}
