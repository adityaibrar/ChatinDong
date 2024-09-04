import '../entities/user_authentication.dart';

abstract class AuthRepository {
  Future<User> authRegister({
    required String name,
    required String email,
    required String password,
  });
  Future<User> authLogin({
    required String email,
    required String password,
  });
  Future<User> authSetProfile({
    required User user,
    required String currentId,
    required String imageUrl,
    required String userName,
  });
  Future<void> authSignOut();
  Future<User> authCheck();
}
