import '../entities/user_authentication.dart';
import '../repositories/authentication_repository.dart';

class AuthGetUser {
  final AuthRepository repository;

  AuthGetUser(this.repository);

  Future<User> execute() async {
    return await repository.authCheck();
  }
}