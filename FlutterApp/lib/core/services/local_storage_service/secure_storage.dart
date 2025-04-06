import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'idToken', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'idToken');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'idToken');
  }
}

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  Future<void> saveData({required String value, required String key}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getData(String key) async {
    String? res = await _storage.read(key: key);
    return res;
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  // Future<Base64> getData() async {
  //   String? jsonString = await _storage.read(key: '64DataStorage');
  //   final Base64 obj = base64FromJson(jsonString!);
  //   return obj;
  // }
}
