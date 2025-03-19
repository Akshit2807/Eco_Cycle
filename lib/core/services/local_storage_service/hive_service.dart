import 'package:hive/hive.dart';

import '../../../data/models/user_model.dart';

class HiveService {
  static const String _userBoxName = 'userBox';
  static Box<UserModel>? _userBox;

  static Future<void> initHive() async {
    if (!Hive.isBoxOpen(_userBoxName)) {
      _userBox = await Hive.openBox<UserModel>(_userBoxName);
    } else {
      _userBox = Hive.box<UserModel>(_userBoxName);
    }
  }

  static Future<void> saveUserModel(UserModel user) async {
    await initHive();
    await _userBox?.put('user', user);
  }

  static Future<UserModel?> getUserModel() async {
    await initHive();
    return _userBox?.get('user');
  }

  static Future<void> clearUser() async {
    await initHive();
    await _userBox?.delete('user');
  }
}
