import '../datasources/authentication_data_source.dart';
import '../../domain/entities/user_authentication.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;

  AuthRepositoryImpl(this.firebaseAuthDataSource);

  @override
  Future<User> authLogin(
      {required String email, required String password}) async {
    return await firebaseAuthDataSource.authLogin(
        email: email, password: password);
  }

  @override
  Future<User> authRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    return await firebaseAuthDataSource.authRegister(
        name: name, email: email, password: password);
  }

  @override
  Future<void> authSignOut() async {
    return await firebaseAuthDataSource.authSignOut();
  }
}
