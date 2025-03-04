import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _storage = FlutterSecureStorage();

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
  static const _storage = FlutterSecureStorage();

  Future<void> saveData(String path, String key) async {
    await _storage.write(key: key, value: path);
  }

  Future<String?> getData(String key) async {
    String? path = await _storage.read(key: key);
    return path;
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
