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
