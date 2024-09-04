import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/user_authentication.dart';
import '../models/user_model.dart';

class UserLocalDataSources {
  static const String _userValueKey = 'user';
  static const String _profileSetUpKey = 'isProfileSetUp';
  final FlutterSecureStorage secureStorage;

  UserLocalDataSources(this.secureStorage);

  Future<void> saveUser({required User user}) async {
    final userJson = jsonEncode((user as UserModel).toJson());
    await secureStorage.write(key: _userValueKey, value: userJson);
  }

  Future<User?> getUser() async {
    final userJson = await secureStorage.read(key: _userValueKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  Future<void> clearUser() async {
    await secureStorage.delete(key: _userValueKey);
  }

  Future<void> saveSetUpStatus({required bool isSetUp}) async {
    await secureStorage.write(key: _profileSetUpKey, value: isSetUp.toString());
  }

  Future<bool> isProfileSetUp() async {
    final isSetUp = await secureStorage.read(key: _profileSetUpKey);

    return isSetUp == 'true';
  }

  Future<void> clearIsSetUp() async {
    await secureStorage.delete(key: _profileSetUpKey);
  }
}
