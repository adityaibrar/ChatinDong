import 'dart:convert';

import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/user_authentication.dart';

class UserLocalDataSources {
  static const String _userValueKey = 'user';
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
}
