import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ISecureStorage {
  Future<void> writeSecureData(String key, String value);

  Future<String?> readSecureData(String key);

  Future<void> deleteSecureData(String key);

  Future<bool> containsKeyInSecureData(String key);
}

class SecureStorage extends ISecureStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  @override
  Future<String?> readSecureData(String key) => _secureStorage.read(key: key);

  @override
  Future<bool> containsKeyInSecureData(String key) =>
      _secureStorage.containsKey(key: key);

  @override
  Future<void> deleteSecureData(String key) => _secureStorage.delete(key: key);

  @override
  Future<void> writeSecureData(String key, String value) =>
      _secureStorage.write(key: key, value: value);
}
