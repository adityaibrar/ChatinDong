import '../entities/user_authentication.dart';
import '../repositories/authentication_repository.dart';

class AuthLogin {
  final AuthRepository authRepository;

  const AuthLogin(this.authRepository);

  Future<User> execute(
    String email,
    String password,
  ) async {
    return await authRepository.authLogin(email: email, password: password);
  }
}
