import 'dart:convert';

import 'package:test_web_app/data/secure_storage.dart';
import 'package:test_web_app/domain/models/user_data.dart';
import 'package:test_web_app/get_it.dart';
import 'package:uuid/uuid.dart';

abstract class IAuthenticationRepository {
  Future<bool?> login({
    required AuthUserRequest user,
  });
  Future<bool?> logout();
  Future<bool?> isLoggedIn();
}

class AuthenticationRepository implements IAuthenticationRepository {
  final ISecureStorage _secureStorage = getIt<ISecureStorage>();

  static const String _userLoggedKey = "user_logged_key";

  @override
  Future<bool?> login({
    required AuthUserRequest user,
  }) async {
    try {
      final isLoggedIn = await this.isLoggedIn();
      if (isLoggedIn == true) {
        return true;
      }
      final valid = user.validate();
      if (!valid) {
        return false;
      }
      const uuid = Uuid();
      final authUser = AuthUserData(email: user.email, accessToken: uuid.v4());
      final jsonData = json.encode(authUser);
      await _secureStorage.writeSecureData(_userLoggedKey, jsonData);
      return true;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool?> isLoggedIn() async {
    try {
      final jsonBearerData = await _secureStorage.readSecureData(_userLoggedKey);
      if (jsonBearerData != null) {
        final bearerDataMap = json.decode(jsonBearerData) as Map<String, dynamic>;
        final data = AuthUserData.fromJson(bearerDataMap);
        if (data.accessToken != null) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool?> logout() async {
    try {
      await _secureStorage.deleteSecureData(_userLoggedKey);
      return true;
    } catch (e) {
      return null;
    }
  }
}
