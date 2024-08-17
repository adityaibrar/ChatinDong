part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class SuccesRegister extends AuthenticationState {
  final User user;
  const SuccesRegister(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthenticationState {
  final String e;

  const AuthError(this.e);

  @override
  List<Object> get props => [e];
}
