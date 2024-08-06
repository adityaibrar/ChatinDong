import '../entities/user_authentication.dart';
import '../repositories/authentication_repository.dart';

class AuthRegister {
  final AuthRepository authRepository;

  const AuthRegister(this.authRepository);

  Future<User> execute(
    String name,
    String email,
    String password,
  ) async {
    return await authRepository.authRegister(
      name: name,
      email: email,
      password: password,
    );
  }
}
