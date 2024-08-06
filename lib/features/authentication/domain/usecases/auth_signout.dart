import '../repositories/authentication_repository.dart';

class AuthSignOut {
  final AuthRepository authRepository;

  const AuthSignOut(this.authRepository);

  Future<void> execute() {
    return authRepository.authSignOut();
  }
}
