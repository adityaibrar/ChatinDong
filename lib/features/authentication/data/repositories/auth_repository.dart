import '../../domain/entities/user_authentication.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_data_source.dart';
import '../datasources/user_local_storage_data_sources.dart';
import '../models/user_model.dart';

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
    await userLocalDataSources.clearIsSetUp();
  }

  @override
  Future<User> authCheck() async {
    final user = await userLocalDataSources.getUser();
    if (user == null) {
      throw Exception('User not found');
    }
    return user;
  }

  @override
  Future<User> authSetProfile({
    required User user,
    required String currentId,
    required String imageUrl,
    required String userName,
  }) async {
    try {
      final UserModel userModel = UserModel(
        uid: user.uid,
        name: userName,
        email: user.email,
        imageUrl: imageUrl,
        createdAt: user.createdAt,
      );
      final userUpdateModel = await firebaseAuthDataSource.setUpProfile(
        user: userModel,
        currentId: currentId,
        imageUrl: imageUrl,
        userName: userName,
      );
      await userLocalDataSources.saveUser(user: userUpdateModel);
      await userLocalDataSources.saveSetUpStatus(isSetUp: true);
      return userUpdateModel;
    } catch (e) {
      throw Exception('Terjadi Kesalahan saat update profile: $e');
    }
  }
}
