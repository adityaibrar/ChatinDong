import '../features/authentication/data/datasources/authentication_data_source.dart';
import '../features/authentication/data/repositories/auth_repository.dart';
import '../features/authentication/domain/repositories/authentication_repository.dart';
import '../features/authentication/domain/usecases/auth_login.dart';
import '../features/authentication/domain/usecases/auth_register.dart';
import '../features/authentication/domain/usecases/auth_signout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setUpInjection() {
  //Firebases
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseFirestore.instance);

  //DataSources
  locator.registerLazySingleton(
      () => FirebaseAuthDataSource(locator(), locator()));

  //Implementations
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator()));

  //UseCases
  locator.registerLazySingleton(() => AuthLogin(locator()));
  locator.registerLazySingleton(() => AuthRegister(locator()));
  locator.registerLazySingleton(() => AuthSignOut(locator()));
}
