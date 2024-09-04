import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../features/authentication/data/datasources/authentication_data_source.dart';
import '../features/authentication/data/datasources/user_local_storage_data_sources.dart';
import '../features/authentication/data/repositories/auth_repository.dart';
import '../features/authentication/domain/repositories/authentication_repository.dart';
import '../features/authentication/domain/usecases/auth_get_user.dart';
import '../features/authentication/domain/usecases/auth_login.dart';
import '../features/authentication/domain/usecases/auth_register.dart';
import '../features/authentication/domain/usecases/auth_set_profile.dart';
import '../features/authentication/domain/usecases/auth_signout.dart';
import '../features/chat/data/datasources/chat_remote_data_source.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/chat/domain/usecases/get_message.dart';
import '../features/chat/domain/usecases/send_message.dart';
import '../features/friends/data/datasources/friend_remote.dart';
import '../features/friends/data/repositories/friend_repository.dart';
import '../features/friends/domain/repositories/friend_repository.dart';
import '../features/friends/domain/usecases/add_friends.dart';
import '../features/friends/domain/usecases/get_friends.dart';
import '../features/friends/domain/usecases/search_friends.dart';
import '../features/friends/domain/usecases/search_people.dart';

final GetIt locator = GetIt.instance;

Future<void> setUpInjection() async {
  //flutter_secure_storage
  locator.registerLazySingleton(() => const FlutterSecureStorage());

  //Firebases
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseFirestore.instance);
  locator.registerLazySingleton(() => FirebaseMessaging.instance);

  //DataSources
  locator.registerLazySingleton(
      () => FirebaseAuthDataSource(locator(), locator()));
  locator.registerLazySingleton(() => UserLocalDataSources(locator()));
  locator.registerLazySingleton(() => FriendRemoteDataSources(locator()));
  locator.registerLazySingleton(() => ChatRemoteDataSource(locator()));

  //Implementations
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator(), locator()));
  locator.registerLazySingleton<FriendRepository>(
      () => FriendRepositoryImpl(locator()));
  locator.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(locator()));

  //UseCases
  locator.registerLazySingleton(() => AuthLogin(locator()));
  locator.registerLazySingleton(() => AuthRegister(locator()));
  locator.registerLazySingleton(() => AuthSignOut(locator()));
  locator.registerLazySingleton(() => AuthGetUser(locator()));
  locator.registerLazySingleton(() => AuthSetProfile(locator()));
  locator.registerLazySingleton(() => SearchPeople(locator()));
  locator.registerLazySingleton(() => AddFriends(locator()));
  locator.registerLazySingleton(() => GetFriends(locator()));
  locator.registerLazySingleton(() => SearchFriends(locator()));
  locator.registerLazySingleton(() => GetMessage(locator()));
  locator.registerLazySingleton(() => SendMessage(locator()));
}
