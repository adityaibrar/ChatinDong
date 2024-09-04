import '../entities/user_authentication.dart';
import '../repositories/authentication_repository.dart';

class AuthSetProfile {
  final AuthRepository authRepository;

  const AuthSetProfile(this.authRepository);

  Future<User> execute({
    required User user,
    required String currentId,
    required String imageUrl,
    required String userName,
  }) async {
    return authRepository.authSetProfile(
      user: user,
      currentId: currentId,
      imageUrl: imageUrl,
      userName: userName,
    );
  }
}
