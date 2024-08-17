import '../datasources/user_local_storage_data_sources.dart';

import '../datasources/authentication_data_source.dart';
import '../../domain/entities/user_authentication.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final UserLocalDataSources userLocalDataSources;

  AuthRepositoryImpl(
    this.firebaseAuthDataSource,
    this.userLocalDataSources,
  );

  @override
  Future<User> authLogin({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuthDataSource.authLogin(
      email: email,
      password: password,
    );

    await userLocalDataSources.saveUser(user: user);

    return user;
  }

  @override
  Future<User> authRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    return await firebaseAuthDataSource.authRegister(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> authSignOut() async {
    await firebaseAuthDataSource.authSignOut();
    await userLocalDataSources.clearUser();
  }

  @override
  Future<User> authCheck() async {
    final user = await userLocalDataSources.getUser();
    if (user == null) {
      throw Exception('User not found');
    }
    return user;
  }
}
