part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class SearchPeopleEvent extends FriendsEvent {
  final String query;

  const SearchPeopleEvent(this.query);

  @override
  List<Object> get props => [query];
}

class AddFriendsEvent extends FriendsEvent {
  final Friend friend;

  const AddFriendsEvent(this.friend);

  @override
  List<Object> get props => [friend];
}

class SearchMyFriends extends FriendsEvent {
  final String query;

  const SearchMyFriends(this.query);

  @override
  List<Object> get props => [query];
}

class GetFriendsEvent extends FriendsEvent {}
