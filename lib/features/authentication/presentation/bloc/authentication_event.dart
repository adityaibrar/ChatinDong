part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class Login extends AuthenticationEvent {
  final String email;
  final String password;

  const Login({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class Register extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;

  const Register({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class SetUpProfileEvent extends AuthenticationEvent {
  final String imageUrl;
  final String userName;

  const SetUpProfileEvent({
    required this.imageUrl,
    required this.userName,
  });

  @override
  List<Object> get props => [ imageUrl, userName];
}

class Logout extends AuthenticationEvent {}

class Check extends AuthenticationEvent {}
