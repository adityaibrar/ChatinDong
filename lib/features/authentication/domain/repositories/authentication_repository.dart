import '../entities/user_authentication.dart';

abstract class AuthRepository {
  Future<User> authRegister(
      {required String name, required String email, required String password});
  Future<User> authLogin({required String email, required String password});
  Future<void> authSignOut();
}
